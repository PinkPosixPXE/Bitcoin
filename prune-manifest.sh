#!/bin/bash
## prune_manifest.sh ##
## Prune Bitcoin Manifests ##
## Author: PinkPosixPXE - 11/2014 ##

### Contribution to The Bitcoin Foundation - "The Real Bitcoin" 
### As per the Bitcion Foundations Requirements, this has been squeezed 
### to fit within an 80col width. This script works with the installation
### steps, and files/manifest, and release, detailed in the STATE OF BITCOIN ADDRESS
### shown below.
### STATE OF BITCOIN ADDRESS - RELEASE NOTES
### 	http://therealbitcoin.org/ml/btc-dev/2014-December/000017.html
### Patching The Reference Implementation: A Guide (README)
###	http://therealbitcoin.org/ml/btc-dev/2014-December/000015.html
###
### Pre-Run steps ###
###        chmod +x prune-manifest.sh
###        ./prune-manifest.sh
###
###        The following commands are optional, their output should be equal:
###
###        find bitcoin-bitcoin-a8def6b \
###        -xtype f -print0 | xargs -0 sha256sum | wc -l
###        cat chicken/bitcoin-0.5.3-no-crud.sha256.manifest | wc -l
###
###
### [ NOTE ]: Be sure to edit the following two lines/variables to
###           correspond with the appropriate locations of the ``chicken''
###           directory and the unpacked bitcoin-bitcoin-a8def6b directory:

bitcoin="${HOME}/bitcoin-2014-11-23/bitcoin-bitcoin-a8def6b"
chicken="${HOME}/bitcoin-2014-11-23/chicken"

#### MANIFESTS AND FILE LISTS ####
chickenManifest="${chicken}/bitcoin-0.5.3-no-crud.sha256.manifest"
### tmp files created for filelists, comparisons, and pruning ###
newManifest=/tmp/new-bitcoin.manifest
btcManifest=/tmp/bitcoin-a8def6b.manifest
btcFiles=/tmp/bitcoin-a8def6b.files
newFiles=/tmp/new-bitcoin.files
pruneFiles=/tmp/prune-bitcoin.files

### Array to track file varname, for checking before pruning ###
fileArr=(newManifest btcManifest chickenManifest btcFiles newFiles pruneFiles)
####  INIT ####
### Create required manifests, filelists, and prunelists ###
init() {
  cd ${bitcoin}
  ### Ensure our src dirs exist ###
  if [[ ! -d "${bitcoin}" ]]; then
    echo "Error: Can't find bitcoin src path: ${bitcoin}"
    exit 1
  elif [[ ! -d "${chicken}" ]];then
    echo "Error: Can't find chicken src path: ${chicken}"
    exit 1
  fi
  ### clean old tmp files ###
  rm -v ${newManifest} ${btcFiles} ${newFiles} ${pruneFiles} 2>/dev/null
  ### Create manifest of current bitcoin src ###
  find . -xtype f -exec sha256sum {} \; | sort > ${btcManifest}
  while read line;
  do
    mFile=$(echo "${line}" | awk '{print $2}')
    grep "${mFile}" ${chickenManifest} >> ${newManifest}
  done < ${btcManifest}
  ### Manifest parsing ###
  awk '{print $2}' ${btcManifest} | sort >> ${btcFiles}
  awk '{print $2}' ${chickenManifest} | sort >> ${newFiles}
  comm -23 ${btcFiles} ${newFiles} >> ${pruneFiles}
}

checkFiles() {
  ## Test files exist, and aren't empty ##
  for filevar in ${fileArr[*]}
  do
    file="${!filevar}"
    ## Check if file exists, or is mising ##
    test ! -e "${file}" || test ! -s "${file}" &&{
      echo "Error: Required File Missing, or empty: ${file}"
      exit 1
    }
  done
  ### Check files marked for pruning ###
  while read file
  do
    egrep '^'${file}'$' ${newFiles} && {
      echo "Check Failed: required file marked for deletion: ${file}"
      exit 1
    }
  done< ${pruneFiles}
  return 0
}

pruneFiles() {
  echo "Checks Passed -> Pruning unneeded files from manifest"
  ## Prune manifest, dirs, and tmp files ##
  ## If you want it to remove the files quietly, remove the -v ##
  rm -fv $( < ${pruneFiles} ) 2>/dev/null
  rm -fv ${newManifest} ${btcFiles} ${btcManifest} \
  ${newFiles} ${pruneFiles} 2>/dev/null
  rm -rfv ./contrib ./doc ./scripts ./share
}

init
checkFiles
pruneFiles
###### EOF ######
