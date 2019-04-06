# PhD ideas

## Compare fixpoint tools

Compare different tools that calculate fixpoints for logical modeling.

Models used for testing could be of different types:  
- self-contained
- varying the number of input nodes (1-n)
- small to large number of nodes
- small to large number of edges
- scale-free (boolnet generated) vs random (varying K connectivity)
- play with form of the boolean equations
- others ???

Other things that can be done:
- support BNReduction data format by [Veliz-Cuba](https://doi.org/10.1186/1471-2105-15-221) 
in BioLQM
- add support for calculating the fixpoints using the Colomoto docker (python
interface)
- comparison between **BioLQM, Pint, MABOSS and BNReduction** could be done then
in a Jupiter colomoto-enabled notebook!

Further extension/comparisons could be:
- Tamura, 2009 - Integer programming method
- Dubrova, 2009 - SAT-based

## Use Logical modeling to predict single-drug data

Asmund project proposal: mechanistic drug response prediction analysis

Automate drug target profile annotation from:  
- Klaeger publication 2017 Science
- mrc ppu
- Davis publication 2011 (nature biotechnology?)

Omics data (rna, cnv etc):  
- COSMIC
- CCLE

Drug scren data
- Single drug
  - COSMIC/GDSC
  - CCLE
- Combo
  - O'Neil 2016 Molecular cancer therapeutics
  - FDA Holbeck 2017 cancer research publication

**My idea** is more like this:  
Predict drug-response curves from drug combination datasets (GDSC, CCLE), 
using logical modeling for singaling network analysis or translation from 
logical to ODE modeling. Aslo try to predict drug combinations datasets 
(dose-response matrices?). Pretty much what is done in this [paper](https://doi.org/10.1016/j.cels.2018.10.013) with help from [this one](https://doi.org/10.1186/1752-0509-3-98) 
for converting boolean models to continuous.

## Quantum logic formalism instead of logic (boolean)

The **core idea** makes sense: you don't know the state of a protein, but when 
you measure it, only then you really know what it is.  
May also be worth to look at a [game-theoritic approach](https://doi.org/10.1007/11885191_18)
to find attractors and such.

## Harmony Search

Use [this algorithm](https://doi.org/10.1016/j.proeng.2016.07.510) for 
optimizing the boolean equations for gitsbe?

## Druglogics-Pipeline related

#### Train models to cell-specific proliferation

Concept is that random models predict a lot better than cell-specific ones: 
main directive is **proliferation**, not just fitting to a steady state pattern.

#### A bottom-up model building for drug prediction

Start with a model and some observed synergies. Build/train/produce models that
predict the first observed synergy (using Harmony Search?), from them the next
one, etc. You end up with many models that can predict all the observed 
synergies or you try to find out why that cannot happen for example (e.g. 
contrasting synergies?). Do the latest models' stable states or attractors 
correspond to activity of proteins from literature?

#### Simulate cancer resistance

For example, you have some models that predict some (observed) synergies or you
just find some synergistic drug comibnations for these models or per model. 
Then, you modify these models in order to be resistant to these drugs, simulating
thus the cancer rewiring process! Then, you apply (n+1) drug combinations to
win over the resistance (and you do this procedure at more levels to suggest 
3-way, 4-way drug combos and why there might be cancer models that can 'win' 
over these models and continue the proliferation). You end up with super cancer
resistant models and methods to achieve them or reasons why this cannot happen
at all.

