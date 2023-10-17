import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import scipy.stats as stats

import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd

saveLocation = "/.../plots/"


reData= ["/.../melliodora.csv", "/.../sideroxylon.csv"]

sigLevel = 0.05         # tukeys sig thresold
minSize=2000            # min syri event size
xLimits = [0.035,0.070] # plot x-axis min & max

for currRE in reData:
    name = currRE.split("/")[-1].split("~a")[0]
    print(name)

    # read in data
    df = pd.read_csv(currRE, header = 0)

    # remove all regions smaller than minSize
    df = df.loc[df['size'] >= minSize]
    df.reset_index(inplace=True)

    df = df.replace('SYN', 'Syntenic')
    df = df.replace('NOTAL', 'Unaligned')
    df = df.replace('INV', 'Inverted')
    df = df.replace('DUP', 'Duplicated')
    df = df.replace('TRANS', 'Translocated')
    df = df.replace('TE', 'Transposon')
    df = df.replace('gene', 'Gene')

    # extract each type
    types = pd.unique(df['type'])
    groups = df.groupby('type').groups
    syn = df.loc[groups['Syntenic'], 'recombination']
    notal = df.loc[groups['Unaligned'], 'recombination']
    inv = df.loc[groups['Inverted'], 'recombination']
    dup = df.loc[groups['Duplicated'], 'recombination']
    trans = df.loc[groups['Translocated'], 'recombination']
    TE = df.loc[groups['Transposon'], 'recombination']
    gene = df.loc[groups['Gene'], 'recombination']

    # perform anova
    anova = stats.f_oneway(syn, notal, inv, dup, trans, TE, gene)
    if anova[1] <= sigLevel:
        print("  anova: {} - significant".format(anova))
    else:
        print("  anova: {}".format(anova))

    # perform t-tests
    pairs = []
    for t1 in range(len(groups)):
        for t2 in range(t1+1, len(groups)):
            pairs.append((types[t1], types[t2]))

    for t1, t2 in pairs:
        tTest = stats.ttest_ind(df.loc[groups[t1], 'recombination'], df.loc[groups[t2], 'recombination'])
        if tTest[1] <= sigLevel:
            print("  {}, {} - {} - significant".format(t1, t2, tTest))
        else:
            print("  {}, {} - {}".format(t1, t2, tTest))

    print("")

    # perform Tukeys
    tukey = pairwise_tukeyhsd(endog=df['recombination'],     # Data
                              groups=df['type'],   # Groups
                              alpha=0.05)          # Significance level
    tukey.plot_simultaneous()
    print(tukey.summary())

    plt.xlim(xLimits)
    plt.ylabel('Region type',fontsize=16)
    plt.xlabel('Estimated recombination rates (ρ)',fontsize=16)
    plt.title('E. melliodora\nE. sideroxylon',fontsize=14)
    plt.yticks(fontsize=14)
    plt.xticks(fontsize=14)
    plt.savefig("{}/{}.png".format(saveLocation, name), bbox_inches='tight', dpi=600)
    print("\n")
