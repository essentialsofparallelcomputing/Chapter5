# Chapter 5 Parallel algorithms and patterns
This is from Chapter 5 of Parallel and High Performance Computing, Robey and Zamora,
Manning Publications, available at http://manning.com

The book may be obtained at
   http://www.manning.com/?a_aid=ParallelComputingRobey

Copyright 2019-2020 Robert Robey, Yuliana Zamora, and Manning Publications
Emails: brobey@earthlink.net, yzamora215@gmail.com

See License.txt for licensing information.

# Particle collisions psuedocode (Book: listing 5.1)

# PerfectHash hash table write and read (Book: listing 5.2 to 5.3)
     Used in following examples
     Uses autoconf and make
     Has OpenCL GPU code
     Configure ./configure
     Build with make

# PerfectHash Neighbor finding (Book: listing 5.4 to 5.5)
     Run ./neigh and ./neigh2d
     Performance output for various sizes and compute hardware


# PerfectHash Remap (Book: listing 5.6 to 5.7)
     Run ./remap and ./remap2d
     Performance output for various sizes and compute hardware

# PerfectHash Table interpolation (Book: listing 5.8)
     Run ./table and ./tablelarge
     Performance output for various sizes and compute hardware

# PerfectHash Sort (Book: listing 5.9)
     Run ./sort and ./sort
     Performance output for various sizes and compute hardware

# CompactHash (Book: section 5.4.2)
     Build with cmake
     Configure with cmake
     Build with make
     Run ./neigh and ./neigh2d

# CompactHashRemap (Book: listings 5.10 through 5.12)
     Build with cmake
     Configure with cmake
     Build with make
     Run AMR_remap/AMR_remap

# PrefixSums (Book: pseudocode -- will have implementations in Chapters 6 & 7)

# GlobalSums (Book: listings 5.15 through 5.21)
     Build with cmake
     Configure with cmake
     Build with make
     Run ./globalsums
     Outputs performance results for various sizes, hardware, and methods

