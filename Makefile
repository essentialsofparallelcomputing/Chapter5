All: PerfectHash CompactHash GlobalSums #CompactHashRemap

PerfectHash: Perfecthash/neigh2d

Perfecthash/neigh2d:
	cd PerfectHash; ./configure; make; #./neigh2d

CompactHash: CompactHash/neigh2d

CompactHash/neigh2d:
	cd CompactHash; cmake .; make

CompactHashRemap: CompactHashRemap/neigh2d

CompactHashRemap/neigh2d:
	cd CompactHashRemap; cmake .; make

GlobalSums: GlobalSums/neigh2d

GlobalSums/neigh2d:
	cd GlobalSums; cmake .; make

clean:
	cd PerfectHash; make clean; make distclean
	cd CompactHash; make clean; make distclean
	cd CompactHashRemap; make clean; make distclean
	cd GlobalSums; make clean; make distclean
