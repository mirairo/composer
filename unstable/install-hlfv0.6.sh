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
� �b%Y �]o�0���ᦐ� �21�BJ�AI`�U<�%�eS���ABºJզI~$���׎}αq{q��0�`k繵w�'�z�
W]>�RDQ�k�(B��wE��ҩ���R&�bP������5�J
q�_�v�"�8E6�� <譈�6��<k%�م��YC�=X+��fN�t�3{�&�굄f�a��c6:p�L@4��nG��Ff�~�p�{Џ���<��5][�����<�(��f2R���;Rn�Ğ��kk!�oZ-OW�7
6�ڄ��Mm��M�6�7;��l�eY3��&��`a�#ِ��q��rJ1�����O|�$q�Z�É�9�qnE�)R��x2������H�Y�+>?�I�*��S&���s�9<�7ުW�?��Å61���P%�TE!��a��͝�HW�����>�t�[��L�"�+�B��0ڀ��a��2����_* �ă�٪�'������g������n���w*K����%�hTm0���V�P��U�dq��n'c	|�; �qx�n��\7s< Fu�� ���rBK��-�Qsy�p`dc�OP��10�6Rr���b"��\vn�ni�z�L�m�̵�1tHT��F�I�QܠP�_�M�ӭqh�|R��	h-��k�^@e-L�:�U�^�
[��/���X����i��QA��=_�̛n9��5���n����w��zq|������`0��`0��`0��`�M~��� (  