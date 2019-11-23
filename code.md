# Useful Git and Code commands

## Maven remove logging info 

In order to remove unwanted info like `META-INF/MANIFEST.MF already added, skipping` when running mvn commands, find the `/etc/maven/logging/simplelogger.properties` file (or one similar that maven uses and add the following line:

```
org.slf4j.simpleLogger.log.org.codehaus.plexus.archiver.jar.JarArchiver=warn
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

## R benchmark many expressions

```
rbenchmark::benchmark("prev" = {a = 3*7}, "new" = {a = list()}, replications = 1000, columns = c("test", "replications", "elapsed", "relative", "user.self", "sys.self"))
```

## Render Rmarkdown document

```
rmarkdown::render(input = "./file.Rmd", output_format = "html_document", output_dir = "../../docs")
```

## Render many Rmarkdown documents in a dir                                     
                                                                                
Use the below `render_to_HTML.sh` script:                                       
                                                                                
```                                                                             
#!/bin/bash                                                                     
                                                                                
# finds all R notenooks (.Rmd) in current dir                                   
# and renders them to HTML                                                      
                                                                                
if [ "$#" != 1 ]; then                                                          
  echo "Give one parameter: 'all' or 'some'!"                                   
  exit 1                                                                        
else                                                                            
  arg=$1                                                                        
fi                                                                              
                                                                                
if [ $arg == "all" ]; then                                                      
  rmd_files=`ls | grep Rmd`                                                     
elif [ $arg == "some" ]; then                                                   
  # which ones to render?                                                       
  rmd_files=`ls | grep Rmd | grep -v biomarker | grep -v data_prepro | grep -v consensus | grep -v fitness | grep -v prolif`
else                                                                            
  echo "Write: 'all' or 'some'!"                                                
  exit 1                                                                        
fi                                                                              
                                                                                
echo $rmd_files                                                                 
                                                                                
for file in ${rmd_files}; do                                                    
  echo "Rendering "$file"..."                                                   
  Rscript -e "library(rmarkdown); rmarkdown::render(\"./$file\",\"html_document\")"
done                                                                            
```
