import os

# AMPL is useless for this ... so we do it with python

instances = {
	# 1:'south'
	# ,
	# 2:'SupremeCourtyes'
	# ,
	# 3:'SupremeCourtnot'
	# ,
	# 4:'SocialWorkJ'
	# ,
	5:'wafa'
	# ,
	# 6:'divorces'
	# ,
	# 7:'hollyw'
	# ,
	# 8:'scotl'
	# ,
	# 9:'graphprod'
	# ,
	# 10:'netscience'
}

formulations = [
	# 'INTER'
	# ,
	# 'MIN'
	# ,
	# 'MAX'
	# ,
	'UNION'
	# ,
	# 'FULL'	
]

runs = [
 'ALL'
 # ,
 # 'DYN'
 ]
 
def CreateInstance(instance):
	file = open('id.inc', 'w')
	print>>file, instance
	file.close()
	file = open('name.inc', 'w')
	print>>file, '"'+instances[instance]+'"'
	file.close()
def CreateRun(run):
	file = open('run.inc', 'w')
	print>>file, '"'+run+'"'
	file.close()
def CreateFormuation(formulation):
	file = open('formulation.inc', 'w')
	print>>file, '"'+formulation+'"'
	file.close()

def CreateOutput():
	file = open('result.csv', 'w')
	header=''
	header+= 'id;'			.rjust(11)
	header+= 'instance;'	.rjust(21)
	header+= 'n;'			.rjust(11)
	header+= 'p;'			.rjust(11)
	header+= 'm;'			.rjust(11)
	header+= 'Nc;'			.rjust(11)
	header+= 'Q;'			.rjust(11)
	header+= 'Nodes;'		.rjust(11)
	header+= 'Time;'		.rjust(11)
	header+= 'Model;'		.rjust(11)
	header+= 'Violations;'	.rjust(11)
	header+= 'Vars;'		.rjust(11)
	header+= 'MaxVars;'		.rjust(11)
	header+= 'Ctrs;'		.rjust(11)
	header+= 'MaxCtrs;'		.rjust(11)
	header+= 'Run;'			.rjust(11)
	print>>file, header
	# 'id;instance;n;p;m;Nc;Q;Nodes;Time;Model;Violations;Vars;MaxVars;Ctrs;MaxCtrs;Run;'
	file.close()

	
CreateOutput()
for instance in instances:
	for formulation in formulations:
		for run in runs:
			print instance, instances[instance], formulation, run
			CreateInstance(instance)
			CreateRun(run)
			CreateFormuation(formulation)
			cmd = 'ampl clique.run'
			# cmd = 'ampl clique2.run'
			# cmd+= ' > '
			# cmd+=os.path.join('log', instances[instance]+'_'+formulation+'_'+run+'.log')
			# print cmd
			os.system( cmd )
			