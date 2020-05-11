#!/bin/bash

################################################################################
#                                                                              #
#            Implémente l'auto-complétion pour la commande spipsh              #
#                                                                              #
#   À copier dans le bon dossier pour l'auto-complétion de bash.               #
#                                                                              #
#   p.ex. pour ubuntu :                                                        #
#                                                                              #
#     ln -s /chemin/vers/spipsh_completion.sh /etc/bash_completion.d/spipsh    #
#                                                                              #
################################################################################

eval "$(spipsh _register_completion)"
