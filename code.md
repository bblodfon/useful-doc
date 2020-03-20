# Useful Git and Code commands

## Maven remove logging info 

In order to remove unwanted info like `META-INF/MANIFEST.MF already added, skipping` when running mvn commands, find the `/etc/maven/logging/simplelogger.properties` file (or one similar that maven uses and add the following line:

```
org.slf4j.simpleLogger.log.org.codehaus.plexus.archiver.jar.JarArchiver=warn
```

## Git delete local branch that is not "online" anymore

```
git branch -d <branch-name>
git fetch origin --prune
```

## Git show only files that changed on previous commit

```
git show --pretty="" --name-only
```

## Git remove tag (local+remote)                                                                                                                    
```                                                                             
# create                                                                        
git tag -a v1.0.2 -m "My new version!"                                          
                                                                                
# delete everywhere                                                             
git tag -d v1.0.2                                                               
git push origin :refs/tags/v1.0.2                                               
```

## Git no pass or username

First, [add an ssh-key to your github account](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account).

Then, open the file `.git/config` in your repo and change the `[remote "origin"]` url to:
```
url = git+ssh://git@github.com/<USERNAME>/<REPONAME>.git
```

Otherwise, if you want to just **not type the username** change the line:

`url = https://github.com/<USERNAME>/<REPONAME>.git`, to:  
`url = https://<USERNAME>@github.com/<USERNAME>/<REPONAME>.git`

## R benchmark many expressions

```
rbenchmark::benchmark("prev" = {a = 3*7}, "new" = {a = list()}, replications = 1000, columns = c("test", "replications", "elapsed", "relative", "user.self", "sys.self"))
```

## R render document

```
Rscript -e "rmarkdown::render(input = 'test.Rmd', output_format = 'html_document', output_dir = 'docs')"
```
