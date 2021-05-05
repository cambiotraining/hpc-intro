## Set password-less login

To avoid having to type your password every time you login to the HPC, follow these instructions:

1. Open a new terminal (do not login to the HPC)
2. Check whether you already have a _SSH key_: `ls -al ~/.ssh/id_*.pub`. If you do, skip to step 4.
3. Run `ssh-keygen -t rsa` to create a new _SSH key_ 
   - When asked "Enter passphrase" it is recommended that you create one rather than leaving it empty. Then run `eval 'ssh-agent'` followed by `ssh-add` (you will be asked for the passphrase). This ensures the file containing your _SSH key_ is encrypted. 
4. Copy the _key_ to the hpc (you will be asked for your HPC password):
   - `ssh <user>@login.hpc.cam.ac.uk mkdir -p .ssh` 
   - Then `cat .ssh/id_rsa.pub | ssh <user>@login.hpc.cam.ac.uk 'cat >> .ssh/authorized_keys'`

You can now login to the HPC without having to type a password!
