# PhD Plans

## Thesis                                                                       
- Structure thesis/chapters (bookdown/online gitbook)?

## Pipeline
- Ensemble Model biomarker analysis (part of this work is for automated pipeline
paper). Roadmap:
  - Make R package with general useful functions
  - Make R package for biomarker analysis
  - Make bookdown document for previous atopo-based analysis
  - Redo the analysis on Cascade topology and for specific drug combinations (2)
  - Feature importance/biomarker selection using ML methods (compare with what 
you got with your own method, submit to the ML course to get the credits)
  - Submit R packages to CRAN
  - Small publication of the R package and ML methods perhaps?
- Work on the pipeline modules (see the [dev_plan_doc](https://docs.google.com/document/d/1OUupR0b-28YB9pVAww77RMecnFN6A39MYjXMjljmvG4/edit?usp=sharing)). Most important:
    - Full Testing (Junit 5)
    - BioLQM support: stable state calculation, trap spaces
    - Do comparison between Aurelien's BioLQM stable state algorithm and 
BNReduction using M2

## VSM                                                                          
- Make ontologies for genes and proteins known databases (Ensembl, Uniprot) ???     
- PubDictionaries                                                               
- Dictionary Merger/Combiner

## PSICQUIC
- Connect data taken from psicquic to atopo (enxtend atopo module to be 
PSICQUIC-compatible - takes causality information and builds network of 
interactions with available configuration on how to do so).
- Help build [PSICQUIC 2.0](https://github.com/elixir-europe/BioHackathon/tree/master/interoperability/Prototyping%20the%20new%20PSICQUIC%202-0)

## Synergy
- Augment existing R package for calculating reference models to include Wim's 
generalized Bliss method and the mean synergy score by Simone Laderer! Goal 
is to test all the null reference models (Loewe, Bliss, ZIP, +2 new, others?) 
on read dose-response matrix datasets and see which is best at finding the 
synergies. R package to use:
  - SynergyFinder from Finland group [code here](https://github.com/google/synergyfinderengineered/)
  - Also see this software: [R package COMBIA](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5732778/)
- Mathematical formulation of the volume-based synergy score general method to
include (mine)?

