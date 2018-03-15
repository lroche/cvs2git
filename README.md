# Summary
The purpose of cvs2git is to convert a CVS repository to a Git repository. 
All mechanism of conversion is based on [reposurgeon](http://www.catb.org/~esr/reposurgeon/) tool.
The conversion uses the version 3.1.2 of mercurial provided on jessie.


# Launch conversion
    docker run -it lroche/cvs2git modulecvs cvs_remote_url

# Examples
    docker run -it lroche/cvs2git a2ps cvs.savannah.gnu.org

# How to retrieve hg conversion ?

At the end of process, the script launchs a bash session to allow to check the result, here from the example you can get the a2ps-hg directory by using `docker cp` command :

    docker cp <containerId>:/work/a2ps/a2ps-hg .

You can also use a bind mount volume during your run:

    docker run [-it] -v ~/gitconversion/a2ps:/work/a2ps lroche/cvs2git a2ps cvs.savannah.gnu.org

So here the result git repository will be in ~/gitconversion/a2ps/a2ps-git directory on host machine.

# Troubleshooting

- Reposurgeon uses rsync to connect on remote server so sometimes you could get some issues with it:  there is a workaround, only if you have access on cvs server files (,v files), you can copy them on host machine in a directory
named ${project-name}-mirror.
If your project is a2ps and your workdir is ~/gitconversion/a2ps:

    * create a directory named :
~/gitconversion/a2ps/a2ps-mirror
    * place all your files ,v in a directory named ~/gitconversion/a2ps/a2ps-mirror/a2ps
    * create a empty directory named CVSROOT here:
    ~/gitconversion/a2ps/a2ps-mirror/CVSROOT

You should have in ~/gitconversion/a2ps/ this following structure now:
```
├── a2ps-mirror
│   ├── CVSROOT
│   └── a2ps
└── a2ps.map
```
  

# Author map

- The author map allows to specify a full name and email address for each local user ID in the repo you are converting. The expected name file is ${moduleCVSName}.map

So to set a author map file, create a map file in your host machine and use
a bind mount volume to get it in container:

    docker run [-it] -v ~/gitconversion/a2ps:/work/a2ps lroche/cvs2git a2ps cvs.savannah.gnu.org
