
# derived from msvc.diff (PostgreSQL Release 13.2)

###############################################################################################
# This R script dynamically edits Mkvcbuild.pm and vcregress.pl
###############################################################################################

# Required: get the environment variable - postgresrcroot
#
# e.g. set postgresrcroot=C:\projects\postgresql
#
postgresrcroot <- Sys.getenv("postgresrcroot")
postgresrcroot <- normalizePath(postgresrcroot, winslash="/", mustWork = T)


MkvcbuildPathFile <- paste0(postgresrcroot, "/src/tools/msvc/Mkvcbuild.pm")
Mkvcbuild.pm.Lines <- readLines(MkvcbuildPathFile)

insContribExcludesArray <- function(lines) {

  # lines
  LineOnlyBeginPos <- which(grepl("@contrib_excludes\\s+=\\s+\\(", x = lines, perl = TRUE))
  LineAllHaveRightParensPos <- which(grepl("\\)", x = lines, perl = TRUE))
  # after BeginPos, first-found line that has a right paren
  LineOnlyEndPos <- LineAllHaveRightParensPos[head(which(LineOnlyBeginPos <= LineAllHaveRightParensPos),1)]

  ModifyLineWorking <- lines[LineOnlyEndPos]

  # within that line
  # find the right-most paren
  LastParenPos <- tail(gregexpr("\\)", text = ModifyLineWorking, perl = TRUE)[[1L]],1L)
  # insert into that line
  ModifyLineWorking <- paste0(append(strsplit(ModifyLineWorking, split = "")[[1L]], ", 'plr'", after = LastParenPos - 1L), collapse = "")

  lines[LineOnlyEndPos] <- ModifyLineWorking

  writeLines("")
  writeLines("BEGIN insContribExcludesArray ")
  writeLines("")
  writeLines(lines[LineOnlyBeginPos:LineOnlyEndPos])
  writeLines("")
  writeLines("END   insContribExcludesArray ")
  writeLines("")

  return(lines)

}

# 1 - add 'plr' to @contrib_excludes array
Mkvcbuild.pm.Lines <- insContribExcludesArray(Mkvcbuild.pm.Lines)



addProjectCode  <- function(lines) {

  LineOnlyBeginPos    <- which(grepl("sub\\s+mkvcbuild", x = lines, perl = TRUE))
  LineLastPgCryptoPos <- which(grepl("GenerateContribSqlFiles\\s*\\(\\s*'pgcrypto'", x = lines , perl = TRUE))
  # after BeginPos, first-found line
  LineOnlyPos <- LineLastPgCryptoPos[head(which(LineOnlyBeginPos < LineLastPgCryptoPos),1)]

  plrProjectText <-
"\tmy $plr = $solution->AddProject('plr','dll','plr','contrib/plr');
\t$plr->AddFiles(
\t\t'contrib\\plr','plr.c','pg_conversion.c','pg_backend_support.c','pg_userfuncs.c','pg_rsupport.c'
\t);
\t$plr->AddReference($postgres);
\t$plr->AddLibrary('contrib/plr/R$(PlatformTarget).lib');
\t$plr->AddIncludeDir('$(R_HOME)\\include');
\tmy $mfplr = Project::read_file('contrib/plr/Makefile');
\tGenerateContribSqlFiles('plr', $mfplr);

"
  # insert into the file
  lines <- append(lines, strsplit(plrProjectText, split = "\n")[[1L]], after =  LineOnlyPos + 1L)

  writeLines("")
  writeLines("BEGIN AddProjectCode")
  writeLines("")
  writeLines(lines[LineOnlyPos:(LineOnlyPos + 10L)])
  writeLines("")
  writeLines("END   AddProjectCode")
  writeLines("")

  return(lines)

}

# 2 - part of "sub mkvcbuild" - add 'plr' project
Mkvcbuild.pm.Lines <- addProjectCode(Mkvcbuild.pm.Lines)



addGenerateContribSqlFilesCode <- function(lines) {

  # lines
  LineOnlyBeginPos   <- which(grepl("sub\\s+GenerateContribSqlFiles", x = lines, perl = TRUE))

  # pg 11 and later has "return;"
  LineAllHaveReturnsPos <- which(grepl("\\breturn\\s*;", x = lines, perl = TRUE))
  if(length(LineAllHaveReturnsPos)) {
    # after BeginPos, first-found line
    LineOfContribReturnPos <- LineAllHaveReturnsPos[head(which(LineOnlyBeginPos < LineAllHaveReturnsPos),1L)]
  } else {
    # earlier than pg 11
    # just find the function closing end-left-facing-brace
    LineAllHaveReturnsPos <- which(grepl("^}$", x = lines, perl = TRUE))
    LineOfContribReturnPos <- LineAllHaveReturnsPos[head(which(LineOnlyBeginPos < LineAllHaveReturnsPos),1L)]
  }
  plrGenerateContribSqlFilesText <-
"\telse
\t{
\t\tprint \"GenerateContribSqlFiles skipping $n\\n\";
\t\tif ($n eq 'plr')
\t\t{
\t\t\tprint \"mf: $mf\\n\";
\t\t}
\t}
"
  # insert into the file to the position "just above", the "return" statement, xor, "function closing function closing end-left-facing-brace"
  lines <- append(lines, strsplit(plrGenerateContribSqlFilesText, split = "\n")[[1L]], after =  LineOfContribReturnPos -1L)

  writeLines("")
  writeLines("BEGIN addGenerateContribSqlFilesCode")
  writeLines("")
  writeLines(lines[LineOnlyBeginPos:(LineOfContribReturnPos + 7L + 1L + 1L)])
  writeLines("")
  writeLines("END   addGenerateContribSqlFilesCode")
  writeLines("")

  return(lines)

}

# 3 - part of "sub GenerateContribSqlFiles" - add - else 'plr'
Mkvcbuild.pm.Lines <- addGenerateContribSqlFilesCode(Mkvcbuild.pm.Lines)



cat(file = MkvcbuildPathFile, Mkvcbuild.pm.Lines, sep = "\n")


vcregressPathFile <- paste0(postgresrcroot, "/src/tools/msvc/vcregress.pl")
vcregress.pl.Lines <- readLines(vcregressPathFile)

modifySubContribCheck <- function(lines) {

  # lines
  LineOnlyBeginPos   <- which(grepl("sub\\s+contribcheck", x = lines, perl = TRUE))
  LineAllHaveGlobPos <- which(grepl("foreach\\s+my\\s+[$]module\\s+\\(glob\\(", x = lines, perl = TRUE))
  # after BeginPos, first-found line
  LineOfGlobPos <- LineAllHaveGlobPos[head(which(LineOnlyBeginPos < LineAllHaveGlobPos),1L)]

  ModifyLineWorking <- lines[LineOfGlobPos]

  # within that line
  LastAsteriskPos <- tail(gregexpr("[*]", text = ModifyLineWorking, perl = TRUE)[[1L]],1L)

  ModifyLineWorking <- strsplit(ModifyLineWorking, split = "")[[1L]]
  # remove that asterisk
  ModifyLineWorking <- as.list(ModifyLineWorking)
  ModifyLineWorking[LastAsteriskPos] <- NULL
  ModifyLineWorking <- unlist(ModifyLineWorking)
  ModifyLineWorking <- paste0(ModifyLineWorking, collapse = "")

  # insert into the line at the old-asterisk position
  ModifyLineWorking <- paste0(append(strsplit(ModifyLineWorking, split = "")[[1L]], "plr", after = LastAsteriskPos - 1L), collapse = "")
  lines[LineOfGlobPos] <- ModifyLineWorking

  writeLines("")
  writeLines("BEGIN modifySubContribCheck ")
  writeLines("")
  writeLines(lines[LineOnlyBeginPos:LineOfGlobPos])
  writeLines("")
  writeLines("END   modifySubContribCheck ")
  writeLines("")

  return(lines)

}

# 4 - part of sub contribcheck - reduce concern to only 'plr'
vcregress.pl.Lines <- modifySubContribCheck(vcregress.pl.Lines)


cat(file = vcregressPathFile, vcregress.pl.Lines, sep = "\n")

