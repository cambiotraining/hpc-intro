# Practical introduction to High Performance Computing (HPC)

## License

These materials are made available under a [Creative Commons Attribution license](https://creativecommons.org/licenses/by/4.0/). 
This means that you can share and adapt these materials, as long as you give credit to the original materials and authors. 


## Contributing

The materials are written in markdown. 
Files are numbered according to their order in the materials sections. 
Some materials are "extra" and are prefixed with number "99-". 

The `_site.yml` file can be edited to configure the pages that appear on the rendered site. 
This is necessary if a new file is created and we want to add a new page for it. 

The website is built automatically on the `gh-pages` branch when a new push is sent to the repository. 
See below for how to build and preview the site locally.


### Text Boxes

We use some boxes to highlight content, and these can be inserted with the following markdown syntax:

```markdown
:::note
content here
:::
```

We have 4 types of boxes available:

- `:::note` creates an "information" box for side notes, tips and tricks, etc.
- `:::highlight` creates a box to highlight things like learning objectives or key points
- `:::exercise` creates a box for exercises
- `:::warning` creates a box for warnings


### Exercises

To create a new exercise, we use the CSS box `:::exercise` together with an HTML element to hide the answer. 
Here is an example:

```markdown
:::exercise

Ask the question here

<details><summary>Answer</summary>

Answer goes here. 

</details>
:::
```

## Build Website Locally

### Using RStudio

RStudio already has all the dependencies installed, so you can build the site by setting the working directory to your local copy of the repository and run `rmarkdown::render_site()` from the console. 

### From the Terminal

First you need to make sure you have installed: 

* R - [https://www.r-project.org/](https://www.r-project.org/)
* pandoc - [https://pandoc.org/installing.html](https://pandoc.org/installing.html)

Then, install the `rmarkdown` package:

```bash
Rscript -e 'install.packages("rmarkdown")'
```

> Note: On Windows make sure that R is added to Windows PATH. 

You can then build the website with:

```bash
Rscript -e 'rmarkdown::render_site()'
```

If there is no error then you will see a `_site` directory, under which you will find all the html files.
