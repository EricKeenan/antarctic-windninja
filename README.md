# antarctic-windninja
Workflow to dynamically downscale wind speed and direction over Antarctica using the [WindNinja](https://github.com/firelab/windninja) model. 
![](figures/WN_wind_speed.png)

## Example usage
This worfklow currently supports one spatial domain over Pine Island Glacier (PIG) in West Antarctica. 

First, edit job settings in `PIG/job.sbatch`. 

Then, execute dynamic downscalling with `WindNinja`: 
```bash
cd PIG
sbatch job.sbatch
```
## Compute environment
`WindNinja` has a relatively complex chain of dependencies. For this reason, I have exploited containerization technologies including `Docker` and `Singularity`. 

If you would like to use my existing `ubuntu-windninja` `Docker` container, you can pull it from Docker Hub and build it on summit:
```bash
# Switch to a compile node and activate Singularity module
ssh scompile
cache_dir=/scratch/summit/erke2265/ # Update this to your desired directory.
cd ${cache_dir}
ml singularity/3.6.4

# Set singularity cache directories and settings 
SINGULARITY_LOCALCACHEDIR=${cache_dir}
SINGULARITY_CACHEDIR=${cache_dir}
SINGULARITY_TMPDIR=${cache_dir}
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

# Pull image from Docker Hub and activate
singularity pull docker://ekeenan/ubuntu-windninja
singularity run -B ${cache_dir}:${cache_dir} ubuntu-windninja_latest.sif
```

Alternatively, if you would like to build your own Docker container, you can mimic my workflow:
```bash
# Clone repository and build docker image
git clone https://github.com/firelab/windninja.git 
cd windninja 
docker build -t windninja .

# Enter image on the command line (you will need to modify the tag)
docker exec -it ef5a408d440fce5dfe361d865fca754b6d284eaec1706675d010a3293586788b /bin/sh

# Install third-party libraries
apt-get install sudo
sudo apt-get install cmake-curses-gui
cd ../scripts 
./build_deps.sh

# Install (check WindNinja repository for detailed installation instructions) 
mkdir /opt/src/build
cd /opt/src/build
ccmake ../windninja
make && sudo make install
sudo ldconfig
export WINDNINJA_DATA=/opt/src/windninja/data

# Run example 
cd /opt/src/windninja
/opt/src/usr/bin/WindNinja_cli --num_threads 4 data/cli_domainAverage.cfg

# Send docker image from local machine to docker hub 
docker ps -a
docker commit c93a2e0ef80c ubuntu-windninja # The tag is the container's id
docker tag 768516e547e4 ekeenan/ubuntu-windninja # The tag is the image's id
docker push ekeenan/ubuntu-windninja
```

If you would like to build the `WindNinja` momentum solver, use the following:
```bash
# In local terminal
cd /Users/erke2265/Downloads
git clone https://github.com/firelab/windninja.git 
cd windninja 
docker build -t windninja .
# Click run on the image in the docker dashboard
docker ps
docker exec -it 5ce3e6a2870f /bin/bash

# In docker container terminal 
cd /opt/src/
mkdir OpenFOAM
cd OpenFOAM/
wget http://downloads.sourceforge.net/foam/OpenFOAM-2.2.0.tgz
wget http://downloads.sourceforge.net/foam/ThirdParty-2.2.0.tgz
tar xzf OpenFOAM-2.2.0.tgz
tar xzf ThirdParty-2.2.0.tgz
apt-get update
apt-get install build-essential flex bison cmake zlib1g-dev libopenmpi-dev openmpi-bin qt4-dev-tools libqt4-dev libqt4-opengl-dev freeglut3-dev libqtwebkit-dev gnuplot libreadline-dev libncurses-dev libxt-dev
apt-get install libscotch-dev
export FOAM_INST_DIR=/opt/src/OpenFOAM/
. $FOAM_INST_DIR/OpenFOAM-2.2.0/etc/bashrc
cd $WM_PROJECT_DIR
find src applications -name "*.L" -type f | xargs sed -i -e 's=\(YY\_FLEX\_SUBMINOR\_VERSION\)=YY_FLEX_MINOR_VERSION < 6 \&\& \1='
./Allwmake # Can take several hours! 
cd $WM_THIRD_PARTY_DIR
export QT_SELECT=qt4
sed -i -e 's=//#define GLX_GLXEXT_LEGACY=#define GLX_GLXEXT_LEGACY=' \
ParaView-3.12.0/VTK/Rendering/vtkXOpenGLRenderWindow.cxx
./makeParaView
./Allwmake
cd $FOAM_UTILITIES/postProcessing/graphics/PV3Readers 
wmSET $FOAM_SETTINGS
./Allwclean 
./Allwmake
blockMesh -help
mkdir -p $FOAM_RUN/../applications
cp -r /opt/src/windninja/src/ninjafoam/* $FOAM_RUN/../applications
cd $FOAM_RUN/../applications
wmake libso
cd utility/applyInit
wmake
mkdir /opt/src/build
cd /opt/src/build
apt-get install sudo
sudo apt-get install cmake-curses-gui
ccmake ../windninja
make && sudo make install
sudo ldconfig
export WINDNINJA_DATA=/opt/src/windninja/data

cd /opt/src/windninja
/usr/local/bin/WindNinja_cli --num_threads 4 data/cli_momentumSolver_diurnal.cfg

# Back in local terminal
# Send docker image from local machine to docker hub 
docker ps -a
docker commit c93a2e0ef80c windninja-momentum # The tag is the container's id
docker tag 768516e547e4 ekeenan/windninja-momentum # The tag is the image's id
docker push ekeenan/windninja-momentum
```
