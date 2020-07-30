All: Makefile.OpenCL CompactHash GlobalSums CompactHashRemap Scan

Makefile.OpenCL:
	#make -f Makefile.OpenCL

CompactHash: CompactHash/Makefile

CompactHash/Makefile:
	cd CompactHash && cmake . && make && ./neigh2d -r -t 2 -L 6 -o kd hlc hlc1 hlc2 hlc3 && \
	  ./neigh2d -r -t 2 -L 66 -o hlg hlg1 hlg2 hlg3

CompactHashRemap: CompactHashRemap/Makefile

CompactHashRemap/Makefile:
	cd CompactHashRemap && cmake . && make && AMR_remap/AMR_remap_openMP 128 1 4.74  0  100 -adapt-meshgen -no-brute -plot-file

GlobalSums: GlobalSums/globalsums

GlobalSums/globalsums:
	cd GlobalSums && cmake . && make && ./globalsums

clean:
	cd PerfectHash; make clean; make distclean
	cd CompactHash; make clean; make distclean
	cd CompactHashRemap; make clean; make distclean
	cd GlobalSums; make clean; make distclean
