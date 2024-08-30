#!/bin/bash
# Galacticus install script
# Author: Charles Gannon (cgannon@ucmerced.edu)
# Downloads and installs Galacticus (https://github.com/galacticusorg/galacticus) and it's dependencies

# Is program is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the 
# Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <https://www.gnu.org/licenses/>. nstall the latest galacticus binaries + download necessary datasets 

echo "Begin: install galacticus from prebuilt  binary"
installdir="galacticus-$(date +'%m-%d-%Y-%T')"

if test -d $installdir; then 
	echo "ERROR: Directory $installdir already exists"
	exit 1	
fi

function checkdwnld(){
	if [ "$1" -eq -1 ] ; then
		echo "ERROR: Failure when downloading galacticus or it's dependancies"
		exit 1
	fi 
}

echo "Installing in $installdir"
mkdir $installdir
cd $installdir
echo "Downloading Galacticus master and datasets"
check=$(wget https://github.com/galacticusorg/galacticus/archive/master.zip -O galacticus.zip)
checkdwnld $check
check=$(wget https://github.com/galacticusorg/datasets/archive/master.zip -O datasets.zip)
checkdwnld $check
echo "Done!"
echo "Extracting Galacticus master and datasets"
unzip galacticus.zip
unzip datasets.zip
echo "Done"
echo "Cleaning up"
rm galacticus.zip datasets.zip
echo "Done"
cd datasets-master
echo "Downloading tools"
check=$(wget https://github.com/galacticusorg/galacticus/releases/download/bleeding-edge/tools.tar.bz2)
checkdwnld $check
echo "Done"
echo "Extracting tools"
tar xvfj tools.tar.bz2
echo "Done"
echo "Downloading galacticus binary"
cd ..
check=$(wget https://github.com/galacticusorg/galacticus/releases/download/bleeding-edge/galacticus.exe)
checkdwnld $check
echo "Done"
chmod u=wrx galacticus.exe
echo "Installation complete!"
echo "Running a test"

#Run a quick test to make sure installation has been sucessfull
export GALACTICUS_EXEC_PATH=.
export GALACTICUS_DATA_PATH=datasets-master

if ./galacticus.exe galacticus-master/parameters/quickTest.xml ; then
	echo "Test Successful!"
else
	echo "ERROR: Test Failed!"
fi
rm galacticus.hdf5
