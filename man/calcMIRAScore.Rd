% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MIRA.R
\name{calcMIRAScore}
\alias{calcMIRAScore}
\title{Score methylation profile based on its shape}
\usage{
calcMIRAScore(binnedDT, shoulderShift = "auto", method = "logRatio",
  usedStrand = FALSE, regionSetIDColName = "featureID",
  sampleIDColName = "sampleName")
}
\arguments{
\item{binnedDT}{A data.table with columns for:
bin ("bin"), methylation level ("methylProp"), 
region set ID/name (default expected column name is "featureID" 
but this is configurable via a parameter), sample name (default expected column name is 
"sampleName" but this is configurable via a parameter). 
The bin column is not used for calculations since it is assumed by
the function that the rows will be in the order of the bins (so the
function will work without a bin column although the bin column assists
in human readability of the input data.table)}

\item{shoulderShift}{Used to determine the number of bins away from the 
center to use as the shoulders. Default value "auto" optimizes the 
shoulderShift variable for each sample/region set combination to try find the 
outside edges of the dip. shoulderShift may be manually set as an integer
that will be used for all sample/region set combinations. "auto" does not 
currently work with region sets that include strand info.

Brief description/example of the algorithm for "auto": for concave up MIRA
profiles with an odd number of bins, the first potential shoulder 
will be the 2nd bin from the center (if the center was 0). This is
the first bin that could not be included in center methylation value for 
scoring. From there, the shoulder will be changed to the next bin towards
the outside of the profile if the next bin over has a higher methylation
value or if the average methylation value of the next two bins are 
higher than the methylation value of the current shoulder bin. The 
potential shoulder bin keeps moving outward toward the edges of the MIRA
profile until neither of these conditions are met and whatever
bin it stops on is used for the shoulder in the MIRA
score calculation. For symmetrical MIRA profiles (the general use case),
the shoulders picked on both sides of the center will be the same number of 
bins away from the center bin (symmetrical shoulders).}

\item{method}{The scoring method. "logRatio" is the log of the ratio of outer
edges to the middle. This ratio is the average of outside values 
of the dip (shoulders) divided by either the center value if 
it is lower than the two surrounding values (lower for concave up profiles or
higher for concave down profiles) or if it is not lower (higher for
concave down profiles), an 
average of the three middle values. For an even binNum, the middle four
values would be averaged with the 1st and 4th being weighted by half (as
if there were 3 values). 
A higher score with "logRatio" corresponds to a deeper dip. "logRatio" is the
only scoring method currently but more methods may be added in the future.}

\item{usedStrand}{If strand information is included as part of an
input region set when aggregating methylation, 
the MIRA profile will probably not be 
symmetrical. In this case, the automatic 
shoulderShift sensing (done when shoulderShift="auto") needs to
be done for both sides of the dip instead of just one side so set
usedStrand=TRUE if strand was included for a region set.
usedStrand=TRUE only has an effect on the function when shoulderShift="auto".}

\item{regionSetIDColName}{A character object. The name of the column
that has region set names/identifiers.}

\item{sampleIDColName}{A character object. The name of 
the column that has sample names/identifiers.}
}
\value{
A data.table with a column for region set ID 
(default name is featureID), sample ID (default name is sampleName), 
and MIRA score (with name "score"). There will
be one row and MIRA score for each sample/region set combination.
The MIRA score quantifies the "dip" of 
the MIRA profile which is an aggregation of methylation 
over all regions in a region set.
}
\description{
This will take a data.table
that has the methylation level in each bin in the MIRA profile and
return a single score. For the "logRatio" method, this score summarizes 
how large the 'dip' 
in methylation is at the center of that methylation profile.
A column for sample ID/name and a column for region set ID/name
should be included in the data.table because a separate score will be given 
for each sample/region set combination.
 
See `method` parameter for details on scoring calculations.
}
\examples{
data("exampleBins")
calcMIRAScore(exampleBins)

}
