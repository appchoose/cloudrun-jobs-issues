# cloudrun-jobs-issues
Step to reproduce the issue on Cloud Run Jobs

- Run `gcloud auth login` 
- Configure a connection to your artifact registry
- Edit the header of [push.sh](push.sh) file 
- Run `./push.sh`

You should observe the following error output : ![](error-output.png)
