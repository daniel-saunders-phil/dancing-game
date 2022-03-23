# dancing-game
An agent-based model for exploring the evolution of gendered behaviour and social learning. The modeling approach draws heavily
on evolutionary game theory and [this book](https://oxford.universitypressscholarship.com/view/10.1093/oso/9780198789970.001.0001/oso-9780198789970).
This project expands on that book to explore how gendered social learning might have co-evolved with gendered behaviour. Results from this project were published [here](https://journals.sagepub.com/doi/10.1177/00483931211049770)

There are four kinds of files in the repository:

The primary file is the model itself. It is written in netlogo.
You can download netlogo or get access to a browser-based netlogo environment [here](https://www.netlogoweb.org/). The fastest way to explore this file is to download it to your computer and then upload the file to Netlogo Web. The file is heavily annotated so you should be able to understand how it behaves from the info tab and understand how it's coded from the code tab.

The second kind of file is the data analysis. The data analysis was originally done with Jupyter notebooks but I've also created version of the file in base python. The data analysis files can be read in a lot of ways but I recommend using Jupyter notebooks if you have them. A browser-based Jupyter notebook is available [here](https://jupyter.org/try) along with a tutorial if you are unfamiliar.

The third type of file is a cluster of csv files which contain a bunch of data produced by the netlogo model. The data analysis file will need to use them to produce figures. If you download the whole repository as a zip, the data analysis files should be able to find the appropriate csv file on it's own. But if you have trouble getting them to communicate, let me know. If you are trying to use the browser-based notebooks linked above, you'll have to [specify a path](https://medium.com/@ageitgey/python-3-quick-tip-the-easy-way-to-deal-with-file-paths-on-windows-mac-and-linux-11a072b58d5f#:~:text=To%20use%20it%2C%20you%20just,for%20the%20current%20operating%20system.) to the zip folder.

The fourth type of file is a pdf of the paper written about this model. This particular paper has not been published but is an expansion on the published piece linked above. It's probably the best place to start if you are interested in this project but unfamiliar with programming or evolutionary game theory. It provides context and justification for the modeling framework and summarizes many of the major results. The other three kinds of files should give you enough tools to reproduce every figure, table and number in the paper. If you run into problems with reproduction, send me an email or raise an issue on github.

I wrote this respository to be as accessible as possible. You shouldn't need an extensive technical background to get the model to go brrr. But still, there some unnecessary hurdles. I hope to add an app that lets you interact with the model directly from your browser, with no immediate steps. We'll see. 
