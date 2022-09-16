params="{
'test':0,
'l1_ratio':100,
'cv':10,
'verbose':1,
'n_jobs':-2,
'random_state':12345,
'adj':100,
'alphas':[1.1**j for j in range(-50,50)],
'outcome_data':'test2a0_outcome.csv.zip',
'input_data':'test2a0_input.csv.zip'
}"

pred=reg.predict(X)

w=np.mean((y.values.ravel()-pred)**2)

# Define model object.
reg=ElasticNetCV(\
  l1_ratio=params['l1_ratio']/params['adj'],\
  cv=params['cv'],\
  verbose=params['verbose'],\
  n_jobs=params['n_jobs'],\
  random_state=params['random_state'],
  alphas=params['alphas'])
# Show input parameters.
print('\nModel parameters:')
print(reg.get_params(deep=False))
print('')
sys.stdout.flush()

# Fit model.
reg.fit(sX,y.values.ravel())

nonzerovars=[X.columns[x] for x in range(0,len(X.columns)) if reg.coef_[x]!=0]
nonzerocoefs=[x for x in reg.coef_ if x!=0]

res=dict()
res['alpha_']=reg.alpha_
res['mes']=np.mean((y.values.ravel()-reg.predict(X))**2)
res['nonzerovars']=\
[X.columns[x] for x in range(0,len(X.columns)) if reg.coef_[x]!=0]
res['nonzerocoefs']=[x for x in reg.coef_ if x!=0]

