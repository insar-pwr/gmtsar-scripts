# gmtsar-scripts
Bash (and csh) scripts to use with GMTSAR processing.

In order to use the .csh scripts, you will need to have 'csh' installed:
  sudo apt-get install csh
 
Please read the descriptions inside scripts, since some of them require a bit of action from your side.

batch_config.sh			-	Creates a batch_tops.config file in current directory
dinsar_iono.sh			-	Calculates interferograms for all Sentinel-1 3 swaths, using ionospheric correction (split spectrum)
get_dates.sh			-	Get a list of Sentinel-1 image dates from a directory with data
grd2png.sh				-	Convert a .grd file into .png image
msbas1.sh				-	Create a GeoTiff LOS file to use with MSBASV3 software
S1_dinsar_dg.sh			-	Create an interferogram (Sentinel-1) based on 1 sub-swath
S1stack_mkdir.sh		-	Create directory structure for SBAS processing of Sentinel-1 data
S1stack_prep.sh			-	Prepare raw data for SBAS processing of Sentinel-1 data
SBASmerge.sh			-	Merge, unwrap and geocode subswaths for SBAS
SBASmerge_continue.sh	-	Continue merging subswaths if stopped for somes reason
sbas_prep.sh			-	Create intf.tab and scene.tab files for SBAS processing
unwrap_intf.csh			-	Unwrap a stack of interferograms defined in intflist file
