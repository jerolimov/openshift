#!/bin/bash

set -ex

ssh-keygen -R $(crc ip)

ssh -i ~/.crc/machines/crc/id_ecdsa core@$(crc ip)
