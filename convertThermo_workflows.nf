//////////////////////////
// Workflow definitions //
//////////////////////////


include {convertThermo} from './convertThermo_processes.nf'


workflow convertThermo{
    take:
    raw_folder
    conv_params

    main:
    rawFiles = channel.fromPath("${raw_folder}/*.raw")
    convertThermo(rawFiles,
		  conv_params)
}
