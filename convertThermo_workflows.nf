//////////////////////////
// Workflow definitions //
//////////////////////////


include {convertThermo} from './convertThermo_processes.nf'


workflow convert{
    take:
    raw_folder
    conv_params

    main:
    rawFiles = channel.fromPath("${raw_folder}/*.raw")
    convert(rawFiles,
	    conv_params)
}
