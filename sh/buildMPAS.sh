#!/bin/bash
# Last modif Peixoto Oct 2015

BASEDIR=/scratch/pd300/Work/Programas/MPAS/UNIVersion
SOURCEDIR=${BASEDIR}/sources
export MPI_PATH=${BASEDIR}/openmpi
export NETCDF_PATH=${BASEDIR}/netcdf
export PNETCDF_PATH=${BASEDIR}/pnetcdf
export PIO_PATH=${BASEDIR}/pio

#clear all modules
module purge
#module load openmpi-x86_64
#module load openmpi-gcc-4.8.2/1.6.5 
module load gcc/4.8.2 
export FC=gfortran
export F77=gfortran
export F90=grortran
export CC=gcc
export MPIFC=mpif90
export MPIF90=mpif90
export MPIF77=mpif77
export MPICC=mpicc

cd $SOURCEDIR
#GET SOURCES
if ! [ -f ${SOURCEDIR}/openmpi-1.6.5.tar.gz ]; then
	wget http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.5.tar.gz
fi
if ! [ -f ${SOURCEDIR}/parallel-netcdf-1.3.1.tar.gz ]; then
	wget http://ftp.mcs.anl.gov/pub/parallel-netcdf/parallel-netcdf-1.3.1.tar.gz
fi
if ! [ -f ${SOURCEDIR}/netcdf-4.1.3.tar.gz ]; then
	wget http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.3.tar.gz
fi
if ! [ -d ${SOURCEDIR}/pio1_6_7 ]; then
	svn export http://parallelio.googlecode.com/svn/trunk_tags/pio1_6_7/
fi

#OPENMPI # not needed if module loaded
cd $BASEDIR
tar xvf ${SOURCEDIR}/openmpi-1.6.5.tar.gz
cd openmpi-1.6.5
./configure --prefix=${MPI_PATH}
make
make install
export LD_LIBRARY_PATH=${MPI_PATH}/lib:$LD_LIBRARY_PATH
export PATH=${MPI_PATH}/bin:$PATH

#NETCDF
cd $BASEDIR
tar xvf ${SOURCEDIR}/netcdf-4.1.3.tar.gz
cd netcdf-4.1.3
./configure --prefix=${NETCDF_PATH} --disable-dap --disable-netcdf-4 --disable-cxx --disable-shared --enable-fortran
make all check
make install
export LD_LIBRARY_PATH=${NETCDF_PATH}/lib:$LD_LIBRARY_PATH
export PATH=${NETCDF_PATH}/bin:$PATH

#PNETCDF
cd $BASEDIR
tar xvf ${SOURCEDIR}/parallel-netcdf-1.3.1.tar.gz
cd parallel-netcdf-1.3.1
./configure --prefix=${PNETCDF_PATH}
make 
make install
export LD_LIBRARY_PATH=${PNETCDF_PATH}/lib:$LD_LIBRARY_PATH
export PATH=${PNETCDF_PATH}/bin:$PATH

#PIO
cd $BASEDIR
cp -a ${SOURCEDIR}/pio1_6_7 .
cd pio1_6_7/pio
./configure --prefix=${PIO_PATH}
make 
make install
export LD_LIBRARY_PATH=${PIO_PATH}/lib:$LD_LIBRARY_PATH
export PATH=${PIO_PATH}/bin:$PATH

export NETCDF=$NETCDF_PATH
export PNETCDF=$PNETCDF_PATH
export PIO=$PIO_PATH

#MPAS
#cd $BASEDIR
#tar xvf ${SOURCEDIR}/MPAS-Release-4.0.tar.gz
#cd MPAS-Release-4.0
#make gfortran CORE=init_atmosphere

#tar xvf ${SOURCEDIR}/x1.10242.tar.gz
#mpirun -np 4 ./init_atmosphere_model







