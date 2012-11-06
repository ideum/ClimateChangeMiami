# Climate Change Miami

Climate Change Miami is an open source exhibit created with the Open Exhibit 1.6 framework. 

The project was funded through a grant from the National Oceanic and Atmospheric Administration (NOAA). You can learn more about the grant and the project on the Miami Science Museum blog. Ideum developed the custom software and designed the interface. Global Imagination developed the Magic Planet spherical display. Miami Science Museum developed the exhibit content. 

For more information see: http://openexhibits.org/download/climatechange-miami/

# Compiling

This exhibit was created using Flash Builder 4.6 and the Flex SDK 4.5.1A. We do not recommend using a different Flex SDK as there may exist memory leaks from the dynamically loaded media files.

Three kiosk applications were compiled from the same source code. The only requirement is that each one must have a unique username and position. These values can be set using the username and position attributes in the Global.xml file:

	<network 
		username="Kiosk3"
		ip="127.0.0.1"
		port="8087"
		position="right"
	/>

# Running

In order to run the application, you must include the media and xml files in the bin folder. These files can be downloaded at: http://openexhibits.org/download/climatechange-miami/

The exhibit was designed to work with the following Global Imagination products:

- Magic Planet spherical display (hardware)
- StoryTeller Magic Planet controller (software)
- DynamicEarth (real-time data service and software)

It is possible to run the exhibit without this hardware, but the functionality will be limited.

# Questions 

For more information see the manual: ClimateChange-Manual.pdf

Questions can be directed towards: support@openexhibit.org
