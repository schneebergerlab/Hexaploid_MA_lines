args = commandArgs(trailingOnly=TRUE)
filename=paste(args[1],'_plot.pdf',sep="")
pdf(filename)
obsexp=read.table('../scripts/R_input.txt')
y1=obsexp[1,]
y2=obsexp[2,]
x=c(1,2,3,4,5,6,7,8,9,10,11,12,13)
plot(x,y1,xlab="Chromosome",ylab="Proportion of Reads",ylim=range(0.00,0.20))
points(x,y2, col='red', ylim=range(0.00,0.20))
axis(1, at=seq(1, 13, by=1))
axis(2, at=seq(0.00, 0.20, by=0.05))
legend("topright",legend=c("Observed", "Expected"), col=c('black', 'red'), pch=c(1,1))
dev.off()
