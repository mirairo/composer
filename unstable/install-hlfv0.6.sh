(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� "4/Y �[o�0�yx�@B(�21��K�AI`�S��&�Ҳ��}v� !a]�j�$�$r9�o���c��"M;�� B��������u�]���w�$IBM�DQ�IbG�j���N�J�$�-@-&V��Ӻ���))"|�;����(�� 𐷢>��� �Yk$��6D�E�����"�n�OW=��m
�^Kl��=f�À���D 4A�R������l�O1	|��A4��k���rh���lp��Q?&	�d�m=�w�\�Ԟ��k1��7E+�h�F�&2�X�u��S�I�&�f�CU��B��F����PGЀC�ֽp9�������'>~���vj�6I���m�VDo�A�:OfcS�K��G�z1���dԧɫp�?OLH+0g�sg5<�7ުW�?���B�w�~��h���u�(����t�U�F�xz��-	WF�w���k�B��0ڀ���P.>�e��!�t@���r�UO>Q��9MN��/A3t����T���p%��ҨZ`>OG��h�:��:��P��L�2��s �c�@�|�1=n�$��.��rAA5�e��<��[�����X��&8d�`��Cb�M6�t����T����|@ۥ��q@2M{xh��vk�q� �f[nT�d����!��6ݚ�6��G_���Rq;��T֢��q��*�RU�B7�~�pl�,Œ �D�O�T$Ϲ���B�s�yS�-��Y!�&�Q�.>|�n��W�O�����p8���p8���p8���p8���O~:$� (  