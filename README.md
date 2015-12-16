
 This is the part of the guide that pertains to using this script. 
 You must use this in conjuction with the entire bitcoin release/manifest or it's essentially pointless... 
 ~ PinkPosixPXE =^..^=  

 0x07] Clean Source Base with PinkPosixPXE's [R.0E] prune-manifest.sh script:

        [ NOTE ]: Be sure to edit the following two lines of the script to
                  correspond with the appropriate locations of the ``chicken''
                  directory and the unpacked bitcoin-bitcoin-a8def6b directory:

                  bitcoin="${HOME}/bitcoin-2014-11-23/bitcoin-bitcoin-a8def6b"
                  chicken="${HOME}/bitcoin-2014-11-23/chicken"

        chmod +x prune-manifest.sh
        ./prune-manifest.sh

        The following commands are optional, their output should be equal:

        find bitcoin-bitcoin-a8def6b \
        -xtype f -print0 | xargs -0 sha256sum | wc -l
        cat chicken/bitcoin-0.5.3-no-crud.sha256.manifest | wc -l


  [ PinkPosixPXE ]:
    3DAE 5385 2AF4 7432 CE3C 9318 FF23 EAA3 D815 427F
    http://bitcoin-otc.com/viewratingdetail.php?nick=pinkposixpxe

