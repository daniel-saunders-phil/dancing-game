# dancing-game
An agent-based model for exploring the evolution of gendered behaviour and social learning. The modeling approach draws heavily
on evolutionary game theory and [this book](https://oxford.universitypressscholarship.com/view/10.1093/oso/9780198789970.001.0001/oso-9780198789970).
This project expands on that book to explore how gendered social learning might have co-evolved with gendered behaviour. Results from this project were published [here](https://journals.sagepub.com/doi/10.1177/00483931211049770)

There are four kinds of files in the repository:

The primary file is the model itself. It is written in netlogo. There are two versions - one is labeled 'simplified'. It's easy to read and play with. The file is heavily annotated so you should be able to understand how it behaves from the info tab and understand how it's coded from the code tab. The second is labeled 'matrix' setup. It's the heavy duty model that I used for big simulation experiments and sensitivity testing. You can download netlogo or get access to a browser-based netlogo environment [here](https://www.netlogoweb.org/). The fastest way to explore this file is to download it to your computer and then upload the file to Netlogo Web. 

The second kind of file is the data analysis. The data analysis was done in Python. I've uploaded it as a Juypter notebook hosted by Google Colab. This means you can run the data analysis directly in your browser, no matter whether you have Python installed or not.

The third type of file is a cluster of csv files which contain a bunch of data produced by the netlogo model. They are stored in the data folder. The Google Colab notebooks have links to their urls so will be able to open and read their contents automatically.

The fourth type of file is a pdf of the paper written about this model. This particular paper has *not* been published but is an expansion on the published piece linked above. It's probably the best place to start if you are interested in this project but unfamiliar with programming or evolutionary game theory. It provides context and justification for the modeling framework and summarizes many of the major results. The other three kinds of files should give you enough tools to reproduce every figure, table and number in the *published* paper. If you run into problems with reproduction, send me an email or raise an issue on github.
