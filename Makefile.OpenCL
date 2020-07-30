All: PerfectHash CompactHashRemap

PerfectHash: Perfecthash/Makefile

Perfecthash/Makefile:
	cd PerfectHash && ./configure && make && ./neigh2d

CompactHashRemap: CompactHashRemap/Makefile

CompactHashRemap/Makefile:
	cd CompactHashRemap && cmake . && make && AMR_remap/AMR_remap_openMP 128 1 4.74  0  100 -adapt-meshgen -no-brute -plot-file

clean:
	cd PerfectHash; make clean; make distclean
	cd CompactHashRemap; make clean; make distclean
