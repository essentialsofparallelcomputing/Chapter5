All: PerfectHash CompactHash GlobalSums CompactHashRemap

PerfectHash: Perfecthash/Makefile

Perfecthash/Makefile:
	cd PerfectHash; ./configure; #make; #./neigh2d

CompactHash: CompactHash/Makefile

CompactHash/Makefile:
	cd CompactHash; cmake .; #make

CompactHashRemap: CompactHashRemap/Makefile

CompactHashRemap/Makefile:
	cd CompactHashRemap; cmake .; #make

GlobalSums: GlobalSums/globalsums

GlobalSums/globalsums:
	cd GlobalSums; cmake .; make

clean:
	cd PerfectHash; make clean; make distclean
	cd CompactHash; make clean; make distclean
	cd CompactHashRemap; make clean; make distclean
	cd GlobalSums; make clean; make distclean
