
CPlatform <- tail(commandArgs(),1)
writeLines(paste0("CPlatform is ", CPlatform))

# Required get the environment variable - postgresrcroot
#
# e.g. set postgresrcroot=C:\projects\postgresql
#
postgresrcroot <- Sys.getenv("postgresrcroot")
postgresrcroot <- normalizePath(postgresrcroot, winslash="/", mustWork = T)

SolutionPathFile <- paste0(postgresrcroot, "/src/tools/msvc/Solution.pm")
Solution.pm.Lines <- readLines(SolutionPathFile)

modifySubDeterminePlatform <- function(lines, CPlatform) {

  # lines
  LineOnlyBeginPos   <- which(grepl("sub\\s+DeterminePlatform", x = lines, perl = TRUE))
  if(CPlatform == "Win32") {
    LineAllHaveCPlatformPos <- which(grepl("x64", x = lines, perl = TRUE))
  }
  if(CPlatform == "x64") {
    LineAllHaveCPlatformPos <- which(grepl("Win32", x = lines, perl = TRUE))
  }
  # after BeginPos, first-found line
  if(CPlatform == "Win32") {
    LineAllHaveCPlatformPos <- which(grepl("x64", x = lines, perl = TRUE))
    LineOfCPlatformPos <- LineAllHaveCPlatformPos[head(which(LineOnlyBeginPos < LineAllHaveCPlatformPos),1L)]
  }
  # after BeginPos, second-found line
  if(CPlatform == "x64") {
    LineAllHaveCPlatformPos <- which(grepl("Win32", x = lines, perl = TRUE))
    LineOfCPlatformPos <- LineAllHaveCPlatformPos[tail(head(which(LineOnlyBeginPos < LineAllHaveCPlatformPos),2L),1L)]
  }

  ModifyLineWorking <- lines[LineOfCPlatformPos]

  # within that line

  if(CPlatform == "Win32") {
    LastCPlatformPos <- tail(gregexpr("x64", text = ModifyLineWorking, perl = TRUE)[[1L]],1L)
  }
  if(CPlatform == "x64") {
    LastCPlatformPos <- tail(gregexpr("Win32", text = ModifyLineWorking, perl = TRUE)[[1L]],1L)
  }

  ModifyLineWorking <- strsplit(ModifyLineWorking, split = "")[[1L]]

  # remove that CPlatform

  ModifyLineWorking <- as.list(ModifyLineWorking)
  if(CPlatform == "Win32") {
    # remove "x64"
    for(i in 1:3) {
      ModifyLineWorking[LastCPlatformPos] <- NULL
    }
  }
  if(CPlatform == "x64") {
    # remove "Win32"
    for(i in 1:5) {
      ModifyLineWorking[LastCPlatformPos] <- NULL
    }
  }

  ModifyLineWorking <- unlist(ModifyLineWorking)
  ModifyLineWorking <- paste0(ModifyLineWorking, collapse = "")

  # insert into the line at the old-CPlatform position
  ModifyLineWorking <- paste0(append(strsplit(ModifyLineWorking, split = "")[[1L]], CPlatform, after = LastCPlatformPos - 1L), collapse = "")

  lines[LineOfCPlatformPos] <- ModifyLineWorking

  writeLines("")
  writeLines("BEGIN modifySubDeterminePlatform ")
  writeLines("")
  writeLines(lines[LineOnlyBeginPos:LineOfCPlatformPos])
  writeLines("")
  writeLines("END   modifySubDeterminePlatform ")
  writeLines("")

  return(lines)

}

# part of sub DeterminePlatform - reduce concern to only "CPlatform"
Solution.pm.Lines <- modifySubDeterminePlatform(Solution.pm.Lines, CPlatform = CPlatform )

cat(file = SolutionPathFile, Solution.pm.Lines, sep = "\n")
