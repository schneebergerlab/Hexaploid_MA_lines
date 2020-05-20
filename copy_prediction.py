#!/usr/bin/env python
from __future__ import print_function
import sys
import numpy as np
import itertools
import csv

def copy_number_array(initCoN,initChrN):
	
	X = [] #create copy number array
	for i in range(initChrN):
		X.append(initCoN) #initializing array with base copy number
	return X	

def objective(CopyArray, Coverage, ObsReads, TotReads,  SumObs ):

	CL = [] #create empty array to store chromosome lengths
	n=len(CopyArray)
	for j in range(n):
		SL = Coverage[j]*CopyArray[j] #total coverage over copies of chromosome
		CL.append(SL)
	T = float(sum(CL)) #updated total genome coverage 
	DA = [] #create empty array to store differences
	for k in range(n):
		OFs=ObsReads[k]/SumObs #observed reads proportion 
		EFs=(Coverage[k]*float(CopyArray[k]))/T #expected reads proportion of new total
		D = abs(OFs - EFs) #difference between observed and expected
		DA.append(D)
	DifferenceSum=sum(DA) #sum of differences
	return DifferenceSum 

def optimalresults(OptCopyArray, ObsReads, Coverage, SumObs, chrn):
    #return observed and expected fractions for optimal result
	TCA=[]
	for m in range(chrn):
		TC=Coverage[m]*OptCopyArray[m] 
		TCA.append(TC)
	Tot=float(sum(TCA))
	ObsFr=[]
	ExpFr=[]
	for l in range(chrn):	
		OF=ObsReads[l]/SumObs
		EF=(Coverage[l]*float(OptCopyArray[l]))/Tot
		ObsFr.append(OF)
		ExpFr.append(EF)
	return(ObsFr,ExpFr)

def final_copy_number(Coverage, ObsReads, TotReads, SumObs, a, b, chrn):
        List={} #create dictionary for copy combination to difference value
	x=range(a,b+1)
	G=itertools.product(x, repeat=chrn) #combinations for range of values
	minimum=float('inf')
	for item in G:

		if item[5] <= 2 and item[6] <= 2 and item[7] <= 2 and item[8] <= 2 and item[9] <= 2 and item[10] <= 2 and item[11] <= 2 and item[12] <= 2: #capping of restriction of copy numbers
                    itemfl=[float(ifl) for ifl in item]
                    CO=objective(itemfl, Coverage, ObsReads, TotReads, SumObs) #current objective value
              
		    if CO > minimum:
			continue
		    caKey=''.join(str(item))
                
		    List[caKey]=CO # add objective value with corresponding copy combination to dictionary
		    minimum=CO
	min_value = min(List.itervalues()) #get minimum values 
	OptCopyArrays = [keyname for keyname in List if List[keyname] == min_value] #get copy combinations corresponding to minimum values
	print(OptCopyArrays)
        if len(OptCopyArrays)==1:
            OptCopy=str(OptCopyArrays)
	    OptCopy=OptCopy.split(',')
	    OptFirst=OptCopy[0].split('(')
	    OptCopy[0]=OptFirst[1]
	    OptLast=OptCopy[chrn-1].split(')')
	    OptCopy[chrn-1]=OptLast[0]
        
            OptCopyFinal=[float(opt) for opt in OptCopy if opt!="['(" and opt!=")']"]
	    ObsExp=optimalresults(OptCopyFinal, ObsReads, Coverage, SumObs, chrn)
	    print("Optimal Combinations: ")
	    print(OptCopyArrays)
            #print(ObsExp)
            with open('optimal_combination.txt', 'w') as opt_comb:
                opt_comb.write(str(OptCopyArrays))
            with open('obs_exp.txt', 'w') as obs_exp:
                obs_exp.write(str(ObsExp))
        else:
            with open('optimal_combination.txt', 'w') as opt_combs:
                opt_combs.write("multiple optimal combinations")
            with open('obs_exp.txt', 'w') as obs_exp_mult:
                obs_exp_mult.write("skipped")
		
copy_prediction = sys.argv[0]
cn=int(sys.argv[1]) #number of chromosomes
N=float(sys.argv[2]) #total number of reads for reference
K=sys.argv[3]
Asue=sys.argv[4]
lowest=int(sys.argv[5])
highest=int(6)

K=K.split(",")
K = [float(k) for k in K]
#print(K)
Asue=Asue.split(",")
Asue = [float(asc) for asc in Asue]

Asue_perAthcopy=[asu/2 for asu in Asue[0:5]] #reference coverage per copy of Athal chr

Asue_perAlyrcopy=[asuf/2 for asuf in Asue[5:13]] #reference coverage per copy of Alyr chr

Asue_percopy=Asue_perAthcopy+Asue_perAlyrcopy
#Asue_percopy=[asu/2 for asu in Asue] #complete array of reference coverages per copy
#Asue_percopy=[asu/2 for asu in Asue]
#print(Asue_percopy)

S=sum(K) #total observed reads

final_copy_number(Asue_percopy, K, N, S,lowest, highest, cn)






	
			
		

	
	
			
		
			
		 


