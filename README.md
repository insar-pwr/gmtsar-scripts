# gmtsar-scripts
Bash (and csh) scripts to use with GMTSAR processing.

In order to use the .csh scripts, you will need to have 'csh' installed:
  sudo apt-get install csh
 
Please read the descriptions inside scripts, since some of them require a bit of action from your side.

batch_config.sh			-	Creates a batch_tops.config file in current directory <br>
dinsar_iono.sh			-	Calculates interferograms for all Sentinel-1 3 swaths, using ionospheric correction (split spectrum) <br>
get_dates.sh			-	Get a list of Sentinel-1 image dates from a directory with data <br>
grd2png.sh				-	Convert a .grd file into .png image <br>
msbas1.sh				-	Create a GeoTiff LOS file to use with MSBASV3 software <br>
S1_dinsar_dg.sh			-	Create an interferogram (Sentinel-1) based on 1 sub-swath <br>
S1stack_mkdir.sh		-	Create directory structure for SBAS processing of Sentinel-1 data <br>
S1stack_prep.sh			-	Prepare raw data for SBAS processing of Sentinel-1 data<br>
SBASmerge.sh			-	Merge, unwrap and geocode subswaths for SBAS<br>
SBASmerge_continue.sh	-	Continue merging subswaths if stopped for somes reason<br>
sbas_prep.sh			-	Create intf.tab and scene.tab files for SBAS processing<br>
unwrap_intf.csh			-	Unwrap a stack of interferograms defined in intflist file<br>
