# Improved-DarkRP-Limit-Job-Bypass
Bypass the darkrp job access limit

- Works on all DarkRP (if you have any bugs, report it in the issues category).

- Add your VIP groups or other specific groups that will have unlimited access, or a configured limit to access your jobs if the limit is reached (that the job is complete) in your DarkRP game mode.

- Configure your jobs and groups easily.
- In the configuration, limit_reached to '0' if you want an unlimited number of slots available for your groups.
- Include a number greater than '0' if you want to define a specific number of slots for your groups.

In your F4 menu, basic players will see 3/2, VIPs or others 3/3 (if you want the extra slots not to be visible for your groups, you have to modify the code of your F4 menu with the function below).

ipr_ovr_jb.f_maxjob( job table RPExtraTeams ) - (client) - Returns the maximum number of slots, based on the values defined in your jobs configuration file. 
