# ENCODE DCC ChIP-Seq pipeline tester
# Author: Jin Lee (leepc12@gmail.com)
import "../../chipseq.wdl" as chipseq

workflow test_idr {
	Float idr_thresh

	String se_peak_rep1
	String se_peak_rep2
	String se_peak_pooled
	String se_ta_pooled

	String ref_se_idr_peak
	String ref_se_idr_bfilt_peak
	String ref_se_idr_frip_qc

	String se_blacklist

	call chipseq.idr as se_idr { input : 
		prefix = "rep1-rep2",
		peak1 = se_peak_rep1,
		peak2 = se_peak_rep2,
		peak_pooled = se_peak_pooled,
		idr_thresh = idr_thresh,
		peak_type = 'regionPeak', # using SPP regionPeaks
		rank = 'signal.value', # need to use signal.value for regionPeaks instead of p.value
		blacklist = se_blacklist,
		ta = se_ta_pooled,
	}

	call chipseq.compare_md5sum { input :
		labels = [
			'se_idr_peak',
			'se_idr_bfilt_peak',
			'se_idr_frip_qc',
		],
		files = [
			se_idr.idr_peak,
			se_idr.bfilt_idr_peak,
			se_idr.frip_qc,
		],
		ref_files = [
			ref_se_idr_peak,
			ref_se_idr_bfilt_peak,
			ref_se_idr_frip_qc,
		],
	}
}
