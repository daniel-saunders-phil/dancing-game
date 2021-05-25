#!/usr/bin/env python
# coding: utf-8

# In[2]:


# imports a series of packages you'll need or
# if you computer doesn't have those packages,
# it will install them for you
# run this cell twice to install and import

try:
    import pandas as pd
except ImportError:
    get_ipython().system('pip install pandas')
    
try:
    import pathlib as pl
except ImportError:
    get_ipython().system('pip install pathlib')
    
try:
    import matplotlib.pyplot as plt
except ImportError:
    get_ipython().system('pip install matplotlib')
    
try:
    from tabulate import tabulate
except ImportError:
    get_ipython().system('pip install tabulate')


# In[4]:


# depicts the frequencies of strategies when the model is configured to
# only contain two unconditional strategies
# always perform A
# always perform B
# this figure is not included in the published version of the paper

file_name = "Typical unconditional strategy distribution.csv"

strategy_frequency = pd.read_csv(file_name,header=19)

x = strategy_frequency['x']
b_freq = strategy_frequency['y']
a_freq = strategy_frequency['y.1']

plt.plot(x, b_freq, label='always B')
plt.plot(x, a_freq, label='always A')
plt.xlabel('time')
plt.ylabel('strategy frequency')
plt.ylim([0,100])
plt.xlim([0,100])
plt.title('unconditional strategy frequencies')
plt.legend();


# In[7]:


# this figure depicts the average payoff for the condition described
# above
# this figure is not included in the published version of the paper

file_name = "typical average-payoff for 2 strategy uncoordinate.csv"

average_payoff = pd.read_csv(file_name,header=17)

x = average_payoff['x']
y = average_payoff['y']

middle = [.5] * 101

plt.plot(x, y)
plt.plot(x, middle, '--', color='gray', label='0.5')
plt.xlabel('time')
plt.ylabel('average payoff')
plt.ylim([0,1])
plt.xlim([0,100])
plt.legend()
plt.title('payoffs with unconditonal strategies');


# In[8]:


# this figure depicts the average payoff of the population
# for the condition where they employ gendered social learning
# and have the full range of strategies
# this figure is not included in the published version of the paper

file_name = "typical average-payoff for 4 strategy gendered learning.csv"

average_payoff = pd.read_csv(file_name,header=17)

x = average_payoff['x']
y = average_payoff['y']

middle = [.5] * 101
seventyfive = [.75] * 101

plt.plot(x, y)
plt.plot(x, middle, '--', color='gray', label='y=.5')
plt.plot(x, seventyfive, '--', color='gray', label='y=.75')
plt.xlabel('time')
plt.ylabel('average payoff')
plt.ylim([0,1])
plt.xlim([0,100])
plt.legend()
plt.title('payoffs with typical conditional strategies');


# In[8]:


file_name = "inertial mech strategy by sex.csv"

full_data = pd.read_csv(file_name, header=6)
full_data.head()

avg_payoff = full_data['global-average-payoff']

avg_po_as_str = str(round(avg_payoff.mean(), 3))

constant_avg_po = [avg_payoff.mean()] * len(avg_payoff)

plt.plot(avg_payoff)
plt.plot(constant_avg_po, "--", label=avg_po_as_str)
plt.xlabel('time')
plt.ylabel('average payoff')
plt.ylim([0,1])
plt.xlim([0,200])
plt.title('all strategies & random selection of learning partners')
plt.legend();


# In[9]:


boys_0 = full_data['count turtles with [strategy = 0 and sex = 0]'] / 50
boys_1 = full_data['count turtles with [strategy = 1 and sex = 0]'] / 50
boys_2 = full_data['count turtles with [strategy = 2 and sex = 0]'] / 50
boys_3 = full_data['count turtles with [strategy = 3 and sex = 0]'] / 50

girls_0 = full_data['count turtles with [strategy = 0 and sex = 1]'] / 50
girls_1 = full_data['count turtles with [strategy = 1 and sex = 1]'] / 50 
girls_2 = full_data['count turtles with [strategy = 2 and sex = 1]'] / 50
girls_3 = full_data['count turtles with [strategy = 3 and sex = 1]'] / 50

plt.plot(boys_0, color='tab:blue', label='always A')
plt.plot(boys_1, color='tab:cyan', label='always B')
plt.plot(boys_2, color='tab:orange', label='A vs males')
plt.plot(boys_3, color='tab:red', label='B vs males')
plt.legend(loc='lower right')
plt.ylabel('strategy frequency')
plt.xlabel('time')
plt.xlim([0,300])
plt.ylim([0,1])
plt.title('frequency of strategies over time for males');


# In[10]:


plt.plot(girls_0, color='tab:blue', label='always A')
plt.plot(girls_1, color='tab:cyan', label='always B')
plt.plot(girls_2, color='tab:orange', label='A vs males')
plt.plot(girls_3, color='tab:red', label='B vs males')
plt.legend(loc='lower right')
plt.ylabel('strategy frequency')
plt.xlabel('time')
plt.xlim([0,300])
plt.ylim([0,1])
plt.title('frequency of strategies over time for females');


# In[5]:


file_name = "Endogenous gendered learning master.csv"

endo_experiment = pd.read_csv(file_name,header=4)

mr = endo_experiment['mutation_rate']
mls = endo_experiment['mutation_learning_styles']
success = endo_experiment['success']

mr_types = mr.value_counts().keys()
mr_types = list(mr_types)
mr_types.sort()
mls_types = mls.value_counts().keys()
mls_types = list(mls_types)
mls_types.sort()

raw_tab_data = []

for s in mr_types:
    
    row = [s]
    
    for ls in mls_types:
        s_group = (mr == s)
        ls_group = (mls == ls)
        success_w_s = success[s_group]
        success_target = success_w_s[ls_group]
        success_rate = round(success_target.mean() * 100,3)
        success_rate = str(success_rate) + '%'
        row.append(success_rate)
        
    raw_tab_data.append(row)

mls_types.insert(0, '')    
raw_tab_data.insert(0, mls_types)

try:
    from tabulate import tabulate
except ImportError:
    get_ipython().system('pip install tabulate')

print('rows = strategic mutation rate')
print('columns = learning style mutation rate')
print(tabulate(raw_tab_data, tablefmt='simple'))


# In[20]:


file_name = "Typical learning style frequencies even proportion start ls-mr = .01.csv"

learn_style_freqs = pd.read_csv(file_name,header=16)

x = learn_style_freqs['x']
y = learn_style_freqs['y']

plt.plot(x, y, label='mutation rate=0.01')
plt.xlabel('time')
plt.ylabel('frequency of gendered social learning')
plt.ylim([0,105])
plt.xlim([0,1000])
plt.legend()
plt.title('low mutation rates');


# In[11]:


file_name = "Typical learning style frequencies even proportion start ls-mr = .2.csv"

learn_style_freqs = pd.read_csv(file_name,header=16)

x = learn_style_freqs['x']
y = learn_style_freqs['y']

plt.plot(x, y, label='mutation rate=0.2')
plt.xlabel('time')
plt.ylabel('frequency of gendered social learning')
plt.ylim([0,105])
plt.xlim([0,1000])
plt.legend()
plt.title('medium mutation rates');


# In[18]:


file_name = "Typical learning style frequencies even proportion start ls-mr = .5.csv"

learn_style_freqs = pd.read_csv(file_name,header=16)

x = learn_style_freqs['x']
y = learn_style_freqs['y']

plt.plot(x, y, label='mutation rate=0.5')
plt.xlabel('time')
plt.ylabel('frequency of gendered social learning')
plt.ylim([0,105])
plt.xlim([0,1000])
plt.legend()
plt.title('high mutation rates');

