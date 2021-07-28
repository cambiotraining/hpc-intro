# Practical introduction to High Performance Computing (HPC)

Course Materials repository. 

## Contributing

The materials are written in markdown. 
Files are numbered according to their order in the materials sections. 
Some materials are "extra" and are prefixed with number "99-". 

The repository is compiled using the `{rmarkdown}` R package. 
From the command line, this would create the html files: 

```console
Rscript -e "rmarkdown::render_site()"
```

The _html_ files are built into the `docs` folder, from which the GitHub pages are built. 

The `_site.yml` file can be edited to configure the pages that appear on the rendered site. 
This is necessary if a new file is created and we want to add a new page for it. 


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
