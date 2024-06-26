# Trainer notes

In general there are two main resources: 

- A [slide deck](https://docs.google.com/presentation/d/1KmnSznETddQdRYa6UAXtT-eMOsW7tEwbsOh0fK62c84/edit?usp=sharing), containing supporting slides for various sections of the course (detailed below).
- [Course materials page](https://cambiotraining.github.io/hpc-intro/), containing detailed explanations of the course content. These materials serve a few purposes:
  - For participants: it's a reference to use after the course (course notes).
  - For trainers: useful to prepare the delivery of materials, i.e. knowing what you should be demonstrating interactively during the course.
  - For exercises during the course - at the relevant point of the course you can point participants to section X for the exercise. 

Below, we give details to help you prepare each section of the materials.


## Introduction to HPC

This is a general introduction to HPC.

- Starts with a presentation which should last ~35 min ([slides](https://docs.google.com/presentation/d/1KmnSznETddQdRYa6UAXtT-eMOsW7tEwbsOh0fK62c84/edit?usp=sharing))
  - The slides have speaker notes, which contain some tips along the way. 
- Then followed by a quiz (see slide 17)
  - Give participants ~5 min to answer the questions.
  - Make sure you **request editor access to the quiz** from us, so you can see the participants' responses.
  - Once people finished answering, you can share the responses on your screen (google forms will make some useful barcharts) and go through the answers and discuss any misconceptions.
- In total the session should take no more than ~1h.
- The slides are equivalent to [chapter 3](https://cambiotraining.github.io/hpc-intro/materials/01-intro.html) of the materials. But these materials are only there as reference material for the participants, you don't need to use them during the course.


## Connecting to a HPC cluster

This quite a short session where the main purpose is to have everyone SSH into the training HPC. 

- Slides 18 - 22; materials [chapter 4](https://cambiotraining.github.io/hpc-intro/materials/02-ssh.html)
- Exercise in slide 21
  - For Windows/MobaXterm users on online courses people sometimes get confused about pasting password on the terminal - this is highlighted in slide 20, make sure to highlight this for online courses. 
  - For in-person courses this is usually less of a problem
- Slide 22: mention the text editors and quickly demo Nano just to remind people how to use it (see speaker notes)
- Although Visual Studio Code appears in the course materials page, it is **extra material** and not covered in the course. 


## Using the SLURM job scheduler

This is the most critical part of the course where participants learn to use SLURM in practice. 

- Slides 24-25: there are just 2 slides to quickly introduce SLURM, then most of the session is interactive (see slide speaker notes)
- You should interactively open your terminal and demonstrate things as in [chapter 5](https://cambiotraining.github.io/hpc-intro/materials/03-slurm.html). 
- The demo is insterspersed with exercises - point people to the relevant section as you go through
- Slide 26: at the end of the demo and exercises go through this summary to wrap-up the session


## Managing software

This covers the topic of loading software using environment modules or managing your own software environments using Conda/Mamba

- Slides 28-35: use these to introduce these topics; look at the speaker notes which give tips for when to switch back to interactive demo.
- Interactive demo and exercises in [chapter 6](https://cambiotraining.github.io/hpc-intro/materials/04-software.html)
- For the `mamba` demonstration make sure to **use the software versions shown in the materials** as we ensured these are pre-cached; otherwise anaconda servers become extremely slow with dozens of users simultaneously pinging their servers to download packages. 
- There is a small section on illustrating how to use Singularity containers
  - This section is optional - if you are runnning over time, skip this (point participants to the materials)


## Parallelising jobs with arrays

- Slides 37-41: do these slides first, followed by the first exercise. Before the exercise you can do an interactive demo using the `parallel_arrays.sh` script provided. 
- Slides 42-46: after exercise come back to slides to explain how the $SLURM_ARRAY_TASK_ID variable can be used. 
- Exercise: there's two identical versions of the exercise, participants can pick either one. Often participants ask further explanations about our scripts, in particular as there is a lot of bash programming. You can point them to the [Unix materials](https://cambiotraining.github.io/unix-shell/materials/02-programming/02-variables.html) if they are not familiar with bash variables. 


## Job dependencies

- Slides 48-56: these slides have simple examples to illustrate types of dependencies
- There are some demo scripts to illustrate each of these dependency types, so you should go back and forth between slides and terminal to demonstrate these (see slide speaker notes)
- There are currently no exercises for this section, but during the demo it's a good idea to give participants some time to explore running example, maybe 5 minutes or so for each (if there is time) 


## Moving files

- Slides 58-71: these go through Filezilla, scp and rsync. Based on feedback from previous courses, there are now slides schematically illustrating how `rsync`/`scp` work, as the syntax can be confusing for those. 
- After going through these slides, there's a mini-exercise, which essentially requires them to transfer the data worked on during the workshop from the HPC to their own computers. 


## HPC resources at the University of Cambridge

- [Separate presentation](https://docs.google.com/presentation/d/1WlRqDjaTR3V-fIPBc0LJm_TLnYjUZRrlbfK8Vb_45zU/edit?usp=sharing)