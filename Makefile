All: Makefile.OpenCL PerfectHash CompactHash GlobalSums # Scan

.PHONY: Makefile.OpenCL PerfectHash CompactHash GlobalSums # Scan

Makefile.OpenCL:
	#make -f Makefile.OpenCL

PerfectHash: Perfecthash/Makefile

Perfecthash/Makefile:
	cd PerfectHash && cmake . && make && ./neigh2d

CompactHash: CompactHash/Makefile

CompactHash/Makefile:
	cd CompactHash && cmake . && make && ./neigh2d -r -t 2 -L 6 -o kd hlc hlc1 hlc2 hlc3 #&& \
	  #./neigh2d -r -t 2 -L 66 -o hlg hlg1 hlg2 hlg3

GlobalSums: GlobalSums/globalsums

GlobalSums/globalsums:
	cd GlobalSums && cmake . && make && ./globalsums

clean:
	cd CompactHash; make clean; make distclean
	cd GlobalSums; make clean; make distclean
