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
� �b%Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�Ht7�V�>[���M��:�r�e0�/�� M��+J������8����8�Aq�@�����cl����j_֩��f/�{��
���O�ih/�{=��ه����O�^ѿ�F���W�����+���7��x�Nqp9�Q� +������W\������O����_����g�8�_Y�ӟ�i�������t�eؙ.��#�)�����k!�GkAQ����:�4�G���럵{������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^�������"^��8�>��x�=�K)c�p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��wO�o�_�ۋ�K�O�?w/���⮲���G�������:��xE���=��R��R�@��nȒ�b�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe���@�9��aRf�[7"��
��긝�0i#��=də=Rg�A����<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�(����,�����y�7Me'��{~�N��"r����;i�:�̢n�5�H�X��`a��� ď�������E�I>�{o-�+����g�	B�B�ӇB�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<���i��b���B�xn���ƒL�>�\G�/��:]dL�A����~�bd�T��M�6�7#Q�o�+��P��Hq���@^�N�2�'1�E]��YF�y���g|���v.��r���6��(^������Y�r,�Y��i6�uه�fó��wsf9�%��M�7������)� �?*j���ѧ�C	���e�5�/�
��Dw�_j�a�l���j�����y·�܎��a��I�B?Ҩ�(T�G��
���#;� � WS�.�
���̽/S$y�@�� � �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t�}X�q��^�湘[��I+\��	���{�Х��Soz�.��Ti�\O���&́�l���9����)g��5 �$./�@�P��
 y;?u2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~�h=��E�F1�>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db���_���������!�*��|���y���P�r��	��������?���������R��/�D�ό���RP��T�?����O�N����W'�)�-�:ASv@ ,и�`.�P�.J(F�GzU��߅2�������������pA�����IA+G�	�2�x���
� 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX��������CV��������?h%��@��W��U���߻��'��T������Q����T�_)x[���^��f�GB��
Sz���B/����`�����:K}��8���`p�{;i2�}��U�>2�2<�$�zo*ͭ��3A>���w���]����t�x�͆�f2o�z�D���D!P����.u�A��U;Ǝ�Y�{R�sT��Q�r68F$����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={�hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ��������g��`��/B�ψ���)��������?�x��w�w� �\��Z��Rp	�_Q�/�b��(^��RP��J�W������C�J=��(A���2p����t���GC�'��]����p�����Q�a	�DX�qX$@H�Ei�$)�����P�/��Ch���2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x��q��釧����Gi���/o����wf���U��.����2�p9�q�������
oo_�ӟ�q���H��t�b��tu����?X��O�H�������?K#t�������6�26�R�[p��,��x4B��x���o���FQi(�������1�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���ϻ����q�w�U���w��P�xj�Q^�e����A���B�D���C�����?�`��?�������/�����s Vrt��_c	K ��o���?�g��Y@�>�3���s�=�J���.�j�u#}�F��K��<��Qh�.�{�@C��~8���ā�ɧ9;�S�żx��ж�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�|FzxH��9|�tH,̹���@8ǻ5u���(J�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey��·A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`)�_:���+����?�W��߄����Vn�o�2�������'��U��R������6���z��ps'���B�ó�ч���7���3C��o�<���� o=2|rz����k����&>q[�_�'� �	!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^�=M��|gs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>R����r���*����?�,��:�S>�����ʠ�{�����Y����j����������7��we�����0����rp9�/��.��ŕ��?KA��+�_��?W���?�|�����Rp��'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0���[���b��(�IW�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^<�c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i��Qg��>Z|�3~��h��O�Ň�����O�B�����A��n���}�j5�F��Zm١��6�'~��`��vҩ{��_wuCW�5r�\ًdb���/��4^F�r}�V��I��e��7ͮ"~�����׫�8����$N���>�E#$���ϿNe�����MjWn���}Ԏ�]׮����nE0]��W��$����sGsY?�9�v��N,���M�jW�i
��b����$��׷���|/��t�7K;*V�k��unm�ە��]�+���Ek���.�7Quй��}CT� �b���>�y���ڗ��h4�·#m_k*ɝ���D�w�:��4̮o_��Yr���vy�Q�=Y��=���jkA֟� ʒ;����N����#�j/��_���V�����֋{��x���!?��S���������ݮ�������+��{���c�-���rQk�a�������|�o�i������^O�,u�p��l��Bd���Q�^�=,|"	�!�#!p�Y�n�>j������Wd���4�X<��^��6	���7|�*��q$�C4dE��o��y�VGƷu���J�3B�+�Ʒ�r��
��$����N�t��ϖ�u���O�������q�*����vz.���b��m�-�����|8J'N2��8��R��8��ĉ=v�+�B*�b�?��
�� �� ?vQ+��C]!���� ��ēL���tz[�}�;���O��s^�~�9Q��д��xf��欓�M.n�-����Cġ�J�St"�!����`�]�4����[�l,%�����T'Oj �>3ؗ�l�L�]wl����(���j 6�(-�5!��K���ڂ�r8Ąi&�tue�UWE@ppb�k�5]�%���&��R;V"��4 X��#vM�q�%b�-#w��uj���T%M��:��41,]��H�b`;��\~�C��t�a��w��~�&����}�x��sf#\�f��y��(���4b	�E��?p�
�m�}|ш_9|�r��xi�Xe�DM�Ԍ[�C�g{QS4�֣)��F�U�E�u�6��Y�tm"N8=�����[�S�+��م�����j|��]���75�I����V������<n���uMitZs��sRM�a렛J���	�U|�����O�g.���#
fOgt�|6܏/H@Y����x��x�P��J�DC��Y�)?�2m%q��P����9��������3�3���E����u�&�i-P��R���J|��oX�=�%�F�����%�����OG���t=]1�-� �����w�i>p��SK�F���i{4��$�#1e�c಄�[�q�ˌ	Z��%1�O�h]<�F��Mε��a�;�؇��&���Veu�zag���^G�#Xww�nAk�����٧<4�7�"��π���z���Xw�j�q��/n��������s�����E<J[v.m��O���]�{l����>V�=>O=��C<��ǃ�`��~^�C�߷��=pT 5�'1�'�L��hz��շw_z�����������_n=��D~���pX����np�4�|ݍ��a ����|�x�y��5�א�][����'�Â��}v��� �ܕ��ts��7��<0!瑃�,�ؼ0`���oR�$^뚴x�I���� BaFV�����C���b!� �v�U�һt�&RU����85��^�,�Խ��J]�]��:(��@V��A4�,],��8�k��Y;g��%X�b��(��͜m��Di�ȷz�0�
�U�:�!�l�Ov�K�
�ə�*Yp�no���e󣡖k�fʒ�N)�������lU��Z�j�ޑR�7�h8m�R�ث���|1"��~F�hh��oV"A��q�>�˗&�Äu���0a�/����a�c6:��'DX{SOpJt��o�!�����Y�����6�|�K�㯓�d:�K+�]*�_�II��vq.��4.u���@b��ജ����7ZL)4�8�t�Js��Ų��u�0HE��Ot|b
]B�#��S`K�J�b�(=��2�P�6zxU���r�\M��`&k�D��(	��e�Z�5}�P϶S�&��J�(���s�mFA����櫯,�sR�5�.(˞7�[�h��V��AgT0����f��X�����ЉG��5��ΰ)F�r�#��p)����	ĘBU�A{�9����������h)S˲�H�:JfIY�/ȮU���##����4e���)�j�`����j�M�Y��,e���� ����֙t��
m�Z��io ���B]�H�U��*e�P������@Y�xb rF�Մ"N�� �#�0<5�����h�K�jYQ쐥�A��(�����A��תu>�poK(-<Ԕ�t���%1��~\UU��Ǹ�'��
��,G�d�*�E�� !�x�1d��.��`�g�`�E�T��S^����[���R� �m]�RJ1�+5}c9�O�|5��R^_��kq�)��������6��v.�f��p����芺����u'��l!���[w�\A�<�*m'��rqAٷϥ�F�̧پs�����NU��;���|W�����"�#w���~O۰EW(]�>eT�!�����}� �Z�T��ŝ���$����ް�j��\Q�R���1zF~���6r	\4TE�E���6��XDނ\���<�m��3ϸ�f��ι�\�zf��/�27�}a�X�Fͪ9�V�^(|��8��͖�^���=�u� ߾.���bR��ב�#f`Ŋ�#?Ev0(�dU7?���
 �ˊ�o?��c۟���'��?o#��F�w�0?��y)�������i{�A�CSZ3W��0*v��=�^~i�A���Ց�Y[�E��ɠa-:+�p����V�,88s4�Y��
X��|��":�'����H��h��2�3�JkX�����iD�WB}�Ec�=#�
��N�G�F��-��TX�1J�;\���s�n�iC���q�ƒ>K�#{0q �5��,&{>B��R�<'�Ocf<4KZC�����&R� �0�Qq�?�������I�	�kh���qȊ���1�H�%�����pY%�����o6�����G���!3HHᎬ���1j�n�04@(��_���ǥ�Qd"z�q��p��1��Xϡ���6�T�uι�l�CS�d>��g�0f{v�"A��܋\���3�{�������s|�O�ayo���D��8��M��\p�oU��4Vm�����M�Ϗ�%2Q�|�#���*�֢r���Ar!(2����Ef����|��,k8?&V.��!���R����r�+�p,�!1��1��	a\�@��h8#�UCH Y��4ڊ���#U�?��F�@�V2
�$�h�49���B�R���|�/R��W�b7�;��0���J�.���_���0tP��]oL
0�aݯdjdZTå�8�A�\
c��x�� �����p��7�ԞB��wyZ4��J!���Ӥ�Ѭ�ұK;o�a9���ߛq����.F�6rʼ�v�Rl��($�A�m�&x�
�E�.��ёr]�'t{�-��<�ߞF4�ZMC4`���]�������4SR�T��� �����^����#KqT�J�y\D. w�n�M`3�~��������C��؟��/=���؋�}���A�1�᭮:<}��nαx���~�e�����G�����m9�{��կ�׷�b�/���7�a���O&x�3����d�k�w�_D�=	��_L� xp�N�~hqE/wEc2��QCv���K~���������Cy�?�}�ŗ�����y�7x�A~� ���v�̍��H���C�t���ӡ	84���|�}��u�N@ڡv:�N����l���z�v��oy��7NA�܄W)3���M�m�@޶�:Kx��s���31t���!~�:��5���8n��3p>�:�R��c�q�f<�3p$���d��zin��:O˙3�D[�93δ gZ�3g�1�8nÜ�3��=���13��y��NZ۔���Gϑ�y^�R�����������=�
si:K  