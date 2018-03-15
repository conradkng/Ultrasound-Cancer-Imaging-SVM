# -*- coding: utf-8 -*-

# @author: kvmu

import numpy as np
from re import match
import matplotlib.pyplot as plt
import os

def get_results(filename):
# This function reads the scan data.
#
# @requires: filename - a valid filename (absolute or relative path)
# @returns: data - a list containing all of the results
    results = []
    fh = open(filename, 'r')
    for line in fh:
        m = match('[0-9]+', line)
        if m is not None:
            results.append(float(line.split('\t')[-1].rstrip()))      
    fh.close()
    return results

rootdir = 'D:\\WOrk\\459Code\\Analysisnew\\459analysis\\svmresults\\'

damped_noise = []
damped_noNoise = []
undamped_noise = []
undamped_noNoise = []

for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        subdir_check = subdir.split('\\')[-1]
        if 'damped_noise' == subdir_check:
            damped_noise.append(get_results(os.path.join(subdir, file)))
        elif 'damped_noNoise' == subdir_check:
            damped_noNoise.append(get_results(os.path.join(subdir, file)))
        elif 'undamped_noise' == subdir_check:
            undamped_noise.append(get_results(os.path.join(subdir, file)))
        elif 'undamped_noNoise' == subdir_check:
            undamped_noNoise.append(get_results(os.path.join(subdir, file)))
        else:
            print("Something went wrong.")

damped_noise = np.asarray(damped_noise)
dn_mean = damped_noise.mean(axis=1)
dn_std = damped_noise.std(axis=1)

undamped_noise = np.asarray(undamped_noise)
udn_mean = undamped_noise.mean(axis=1)
udn_std = undamped_noise.std(axis=1)

damped_noNoise = np.asarray(damped_noNoise)
dnn_mean = damped_noNoise.mean(axis=1)
dnn_std = damped_noNoise.std(axis=1)

undamped_noNoise = np.asarray(undamped_noNoise)
udnn_mean = undamped_noNoise.mean(axis=1)
udnn_std = undamped_noNoise.std(axis=1)

fig, axs = plt.subplots(nrows=2, ncols=2, sharey=True)
ax = axs[0,0]
ax.errorbar(range(len(dn_mean)),dn_mean, yerr=dn_std, fmt='--o')
ax.set_title('dn')
ax.locator_params(nbins=4)

ax = axs[0,1]
ax.errorbar(range(len(dn_mean)),udn_mean, yerr=udn_std, fmt='--o')
ax.set_title('udn')
ax.locator_params(nbins=4)

ax = axs[1,0]
ax.errorbar(range(len(dnn_mean)), dnn_mean, yerr=dnn_std, fmt='--o')
ax.set_title('dnn')
ax.locator_params(nbins=4)

ax = axs[1,1]
ax.errorbar(range(len(udnn_mean)), udnn_mean, yerr=udnn_std, fmt='--o')
ax.set_title('udnn')
ax.locator_params(nbins=4)