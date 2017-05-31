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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� "4/Y �]Ys�:�g�
j^��xߺ��F���6�`��R��ml����t�N'�߾���:IȲ�t�sđp�C����hLC�˧ �A�dqEiyx��GQ��Qǿ (���9�y�m���Z��&�w���r���C�>���I7	���ho��*��q��)� *���������@�X�B�H%�2�f�/ީ.�?JT%�2p������+���p��	�������?��&J�W���'���K�5|�����t5��{�r��N�O�����EI:���Oj�#��?����ʽ������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'�����^������?E���q}����s��RF����� '6d�&�B�z�lC��E�)M��(�2��I}a,0���G	�;e�ւ6U�	�U���I�ϯ}�`!���h�	Z��Աbc���#��s=$(��!
�ܤu�'����p:�IH��$�L�	kW�ˋ#Y�E�[��Җ(z5�����tj��
/=���ѿ)~i���r�r�d�s��r��¨j��|���2���ױ�|p�W�?J��S�O ��/�?/�,�|�6o5�,�M���A&s �5e%����!ǳ�Jܵ���\�'�Y��i�q����k�`jZC�Z��(J~#�D�S�&��p�s�dl�P�S�W�&meq|��!9�G��9����'��6̅;g㣸��B��b�Mn1�z���+1�C�Aɔ�z�ŌF�!�i�A=ާe� v0?�`����#Сs͡��Չ�X,�����^���9�53ϛrw)m-lq�0�U�����L�N�"��$̓��V���Nip�3m�P<Q(tz�S(@d���*.	����c����G�v#f����+6F�T��G~�A�ڀ��,c%�U.܍PޕV�e��(jugJ7u-j6:r����=!98��B���N}���=/���kp+O<��p `�v!r�r�,��t�2	m�&Fv���	��J=2�6H�\�j�D�i��&C.J !P�/k<y:>���D�	t#.b�f)u4������-��ۙr�IҒ�hb�x>��C&�!f�ɱhDsfы��(�e��F��=3��/��t�������ۊ�����Q�S�U�G��?�t��e�5�g9�;�;�ׁzd�5�{���Ǜ�D=q��%���|�!q���^B�Џ��
|Hʐ�zGE󫂩�d�i9���2s��I��G�:��2��4]� �l��b�p����Y.&�ne8�5�5�!���Y������|��,�{�̢��A�晘Y��N�]�����{�Х��Soz�.��Ti�LOT�Z�@n��ð�@
Zoi�rf�m qY�����+ d��TɌ�L�@����C� ���o䠛��>�u�^��[��kSR�F�D�����d:��u\6�.��̶��	�4���Q/%�E�l����ņ�熂�`~�n3�'0 ���臙\���p=E�̺9�8�7!����S���w�7�����!�*��|����y���P��?�>*����+��ϵ~A��9&�r��=B���2�K�������+U�O�����):�I#������8E���!h��Ew�e
���E� W�8�^��w������(��"���+����88�;���p�����Ҏg	}.�@���p����6����̈ɸ!�MS�wL��V-eX��C����c�}��t�Y�̱�1G[+|���i�,�F1�+ٞ�U��{�K��3����R�Q�������e�Z�������j��]��3�*�/$�G��S���m�?�{���
_
�G(L��6.@s^����`�����Fߛ5(�>��.to;M�w��q���G&]���xR�M��5�{&h�G����ޡ��ct�$an�:�9^o�e�����5���@S�(Z��|��t�A��u;�,�=Ѻ��-��٠�H*�{�����Y�i�f�%�S�q�3 ��l(bK Ӑ���3'��ۼ��k�2	]X�7h�y��磅iϞ�P���I`*�e��w{�χf}yX@�I�F�M���^��Ҳ��h�����j"8���cq)e#���K�HȜ'pr�5CZ�?�����g��������g��T�_
*����+��ϵެ�]��G�]��(�V�_
.��+4�".�������KA���W��������R�m�S�*��\��c��;���`h@��C0���xκ��8�0,���0��(͒$eWQ~�ʐ���H�]�%���?�	�"�^�U��csbkL̶��s�u����ؓ��b�J }'̢N�VjhH�h��D�*�G�	�6v�f씶����#Bݞ���%@<Z���&#���9�d�~?���ލ��?J<?��#�/��Q��������=���c�����.����eJ�r��]��R�^�?H�}��r�\�4�c����G������?MW�K���������t��S>e��4B��?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>Z-��2�����?U�?������Ab�h+�S�A��ƒ%`�}��#��A���m^\�YhW���9��u��TO�È�|٘	G��/S����Z������p�i�a��S���}mc�`f���ϻ�����������J��`��$�������+����I��A���B�D���C	�i�7�����W^��j�_����ΑX�Qеr�%,�!?;�y<���%�����øa�Ui��Umv�R_�K� ���s�֣s������{4��i�M;�L(�|�#�W:y_��G�m;��~�ILW����,�-b�Zt3I�K<���39ơ&���k�͛#���T�����f�f����e�'�n��(B�ld���A7��:���6��Zb��x�����y�ք~ހNQe�6�xN��ܩ�۝�ؐ�����^��.uF$��m�4K�|���0�v�X���M�i����o(����]g+�ӌsV)O	kg�O�� r�@ 5�ý�I'�I�D��5?�}z���u}�H��Ґ^<�G������������/����;{�����s��r+7�D������@����R������6���f��ps/���B������qo(�g���@y�@wA޺d�d����5`�5M|��?�O΃��ɱ�&�t��*�{��3i/�eZ�o�JOM���G|k�r�F��0�S錉S��u��(�F"��j�ո��y��!�~��܇.���� ��Y6h��@]��v#x6�қnҷ��`�6��\��^Jfr��{���,�C�7z}��{���46a�D��h�"��������_:�r���*����?�,����S>c�W����!������Y����j��Z�������7��w�s���aX�����r�_n�]���������+��������b������T��V
.��#l��0�D)ơH�p�g0�D|g4�iGp%2`}*�}�\sëS`~+�!�W���B���O)�`�PZ�d����2�f�����9��6ص��"kdKmѢ&/��1�9��v�u%���St/�P\��A@���X�%5�Z߹�#j��������pF�ehr��Lo�W�(�M{hV��y/�ȝ�I>��q��ׇ������������/�V��U
v~��Z�k�/�/J�d7u��+T��6R\j�������!�����tl'��W��u�P7q�^#�ȕ��'��3�j7M���_mΕ�jW5	p������U�o��q��zU��ON��d�~��_4B_�?�:��wi����tR�rk=��V�wS��S��Պ`��k����yh�:����e�|��y�+�v�`���7���]y�.�E����G��%��}}�S���jcOW~r�����p훻ʠ����p;r���}eX��hluuA�E��!��:7�o�*]���!ק/�.�}���F�+|+d�ZQI��`�;j��7Y%az}�(��"׳/7�˃����·����WK����4�3�^����o��:b���"}�a���L���m��a����!?��S������Okӻ]��o��yU������[�����E�����wjj%��*�����8�b{3��ą��f�u�s�����Hj�Z�a�M��@�P�ȏ��Y<��w�Q�����-�����n��z8e���2)���7|�*��q$�C4dE��ola�<.��#��&����M%�3B�+�Ʒ�j��
��$J7��N�d��ϖ�u�p��>��q�O���8+����O/����ƺN�q�\.����P�\p3\�=^��{�P��[���ۺ�Mɵ���m����&�_���M�F����'%�A�~Q>(��1���v[�v���s8\��䞮�?/}������=�3����M���i��������lt1<�d�$3�X�R2��q�ږ�c��'�k ��0�/����n�LˁiVFǢK��0н@4�׀�}2��lnr(aƅ|��yGU�$����C��m��hNԍ��+��Ah�ef�tðJ�@������8X�1�Ȓ�mE�uS�F�ޱJ�3v��qf�zxN�CI���3��dG:��B��LS�n9���^��U�#��!���q����8sq\��CS1��ȬJ�?P��-��oֈ�9|r��xiȘuTx�oU�K��nݜ�E��Y���Ma��M��4�"G�ӥ�l8���hpꛃS�N��N''F~0��|D��uru�N�_T$v �r�UY���`.�u���=�9��jL]�X�A-���,�n"I��,�T�>��V�?d9N�.[<g�tJ��a�yߌ�.#J#����_3�F?�+�ѽ^�ԚbTaFw��A�Y]}(�����%w���:L�Y)c�?fH�z��g �+V����Es��E�R$yP`k�lͼ�����r�������W?���޾���Q%�ق�p:�Xa��ι �g��{p�!���O�,�9����ҭ#2d�c�ǚ����.#&h����Lc<�M��N��ڹt|��w��j�2�]]��dC�ע��.�h�B��k�sˮ�܁�S��^UM���٧<4�7�":�Wv������,l���������5�������������^���@a��Ʃ�����ϯv^k�ą������DO6�"�^�_��Q7��ey4�z=۾jե�
���x8?�y8��3zx�N�;t���kw���?\��Z�|��C�)~���]z�ϟ�^��3حt�	
��\3�C?tB��	�n\z�΍�W�Ϝ��}z�����<���M���M�{��Ma��H֧�y����#rދ�\��r=����F/aL�5�	���xa��B�`h��o3�QX��7, �|��6rDr3o��X��;��%����������2\��4�S�{��Ks�|���z�&��a�2�|=8���fn1/$>g�ۜl�,�I"�6:��s���*�a����t��v����d��"Y��no͢ʤ����il����LH���V��{�o��\�r��bB�3p)(��BB�*��L�l>��^JM)p�뭗B���~�>��S6�f��L�U����"�v�@Xj_�Om�#���'8$�f����bX{j���[�[��kJ6�ƃ��VqW<�$��6�.s����8��+�(Dsy��V�'�ܑPR̄�l��'$ q8d%�a�I#�r
fZp$B�H��Z>�!���1��9d�;�M����V!�Jj���v�V,�#�?�4Y��y�ZJ�Q�\����a�����`��N��\��w�C>?�D��F��W��1)˒Xg�e˝��u�@�Kq��R2��D���L~( �j�@�~�kE��`�n�H�_	��X1��T��D[i�"T�����MNYpF��ZQ�"t�����i��3-)5�,{�gd�*KT��!_���}C�к|�nX9��0vu"Q9�	Ǜ��#����bλU�~p	�T2R�#�&S��
դ�K�}�����*Kl���(Ke���,Q4��
��*\%I��B����Bg�5s����4Ϸ��P�jW�Eyk'�N+�*op;�;�Ĥ� r�}8e	�ɚDp/��2Hz#LʕΔ9�S�=�3�K��	m�ޡ�{[�Z��BI`�7�ҽ��� XB�y�	7�C��[ �ِ���kM�kR��)�=C1�M�l9�nO��i0�)����l����V��6N�F�Os����Zk�}:�v%��A���'֮�8]7�*me��tr買O�Y��L�Y�r��4�VU��]� ��D#�.w�Ѝ�5�j����,���B���A)Y�q�&�Fp�q���%itr�Np1�)�y���̯�6U���~�oi-;Pxh:Nj�$["Np�ٚLm�C7C�����?��}�a�u�N�s�Bg֮�����	K��!hP �T��-�n��ׅ���TyV�Y2��2�������4�(z_�*|�<�2dV�H?�<���-N�U��9�� ���H�����1����!��8�������m}�<���~)X�������Ik�A�EJ=S�b� ȷ��-�Vvn�A���ԑiK�E��Ѡa.:J�p�����,88q4�Q��
���t��"�{����H��p�CS�R�R�_$����(X��]�	�#�--���V����� �y�DP��#[L)��u�6Y��W�Ջ�`��=�*�F�`�@P��)0ZLP��	
i�?���4n�=jb8D,K�$S��CD��x&:����z+1�h��#�F��`�/���;��"]��+CoKAEg���8W�^�|�|cs�hC���T/&[��ER��GP]�6�� LR��r8+70}\�i�^:�����6�8l�8��u�zIwC��N�-S��i�;&�9&>ӊ9˳��C�u*���i+î�;��zX���������}Y<,;������:�d��#l��$�rW�$�c^v��)�����,fPy���8V��3A�IL5(2iE��5eY���0�pyg0aԦ��Ĕ�CdP#����Ʃ-W a�;J��)1-�(L ��%�FH�ܞ.��ax0���p���*&����`��X8l0d7B��yd�]"5����Q�wP��䐨+Q��W���y���bYl�#�����^)U���,���e��F�0�"teK.��w��aMLlI8�st�%y�\/�"�N7��j�)컴���m�q��ǡ��l�o%��}h�l&�
���Br+��6.�[Ͱ]�m�QVk-!�V;\����µ���)��qD�TT^�xM���3|^K�<X�K��߂؄ h��Dq��w���z��8��$�y��N@WXn�E`1�^}�on�^�����^z������������5�aͮ�=|��nv�M'�s�?Q���?|��yYpn8�}�?y�������Ѝ�����7o��O~5���OBߋ����;q���]i��گL���6����*�t������Ǟ�b�w�͟qz�5��o~�zz��Q�)�OS���Л���Wmj�M����6M��	��N�+���+����6�Ӧv��N�g�}�����|����pR�*4P?8K��Y.h�m�t�"B�$�1C�-�z���IC��C���y�)j��3��:�g`J�?��<�8l�x�xG�H�5p9������4�e��=gƎ��sf�i�� {Όm�q\�93G��{�)0�cf΅��"��*m��%�#����V��+F��d';��N���_ۦL$  