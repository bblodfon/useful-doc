# PhD work finished/Done

Just a summary of all the work (the "real" results - investigations/"secondary" 
things are not included - that I have achieved in my PhD until now (to write 
in bookdown soon).

## Pipeline

- First refactoring, bug fixing, source code documentation on Gitsbe, Drabme, 
druglogics2 (druglogics-synergy) modules and most important parallel simulations 
enabled (my first 2-3 months of my PhD)
- Second refactoring, transport modules to maven packaging, added support
for many features (Ongoing work - see [dev_plan_doc](https://docs.google.com/document/d/1OUupR0b-28YB9pVAww77RMecnFN6A39MYjXMjljmvG4/edit?usp=sharing)). 
Most important things achieved:
  - Added tests to modules Gitsbe, Drabme usign JUnit5, mockito, assertJ libraries
  - [druglogics-roc-generator](https://github.com/bblodfon/druglogics-roc-generator)
R shiny app
  - Export support using [BioLQM](https://github.com/colomoto/bioLQM): the 
initial model + best generation models can now be exported through configuration 
options to GINML, SBML-Qual and BoolNet community formats

## VSM

- [VSM Dictionary Bioportal](https://github.com/vsmjs/vsm-dictionary-bioportal/) module

## PSICQUIC

- miTab 2.8 support added to psicquic web service
  - See [psicquic doc here](http://psicquic.github.io/MITAB28Format.html)
  - [miTab 2.8/causalTab paper ]( https://doi.org/10.1093/bioinformatics/btz132)
- Update [JAMI](https://github.com/MICommunity/psi-jami) library to support 
miTab 2.8 - results of the [BioHackathon 2018, Paris](http://bh2018paris.info/)
and the [Marseille GREEKC hackathon event](https://github.com/GREEKC/hackathon-marseille/tree/master/project_descriptions/causal_psicquic).

## Others

- Java Client for RSAT tool [fetch-sequences](https://github.com/bblodfon/rsat-rest-java-clients)
