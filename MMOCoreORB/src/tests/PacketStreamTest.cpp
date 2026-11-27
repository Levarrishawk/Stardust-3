#include "gtest/gtest.h"
#include "system/net/Packet.h"

TEST(PacketStreamTest, ReusedSpaceContainsOnlyInitializedBytes) {
	Packet packet;
	packet.insertInt(0xffffffff);
	packet.setSize(1);
	EXPECT_EQ(1, packet.getOffset());
	packet.setSize(4);
	EXPECT_EQ(0xff, packet.parseByte(0));
	EXPECT_EQ(0, packet.parseByte(1));
	EXPECT_EQ(0, packet.parseShort(2));
}

TEST(PacketStreamTest, InvalidOperationsPreserveCursorAndDestination) {
	Packet packet;
	packet.insertByte(7);
	packet.reset();
	Stream destination("keep", 4);
	EXPECT_THROW(packet.readStream(&destination, 2), StreamIndexOutOfBoundsException);
	EXPECT_THROW(packet.setOffset(-1), StreamIndexOutOfBoundsException);
	EXPECT_THROW(packet.parseShort(0), StreamIndexOutOfBoundsException);
	EXPECT_EQ(0, packet.getOffset());
	ASSERT_EQ(4, destination.size());
	EXPECT_EQ(0, memcmp(destination.getBuffer(), "keep", 4));
	EXPECT_EQ(7, packet.parseByte());
}

TEST(PacketStreamTest, FixedAndSequentialStringReadsAgree) {
	Packet packet;
	packet.insertByte(1);
	packet.insertAscii("abc");
	packet.insertUnicode(UnicodeString("zone"));
	packet.setOffset(1);
	String text;
	packet.parseAscii(1, text);
	EXPECT_STREQ("abc", text.toCharArray());
	EXPECT_EQ(1, packet.getOffset());
	char small[3];
	EXPECT_THROW(packet.parseAscii(small), StreamIndexOutOfBoundsException);
	char exact[4];
	EXPECT_EQ(3, packet.parseAscii(exact));
	EXPECT_STREQ("abc", exact);
	const int cursor = packet.getOffset();
	UnicodeString wide;
	packet.parseUnicode(cursor, wide);
	EXPECT_EQ(UnicodeString("zone"), wide);
	EXPECT_EQ(cursor, packet.getOffset());
	EXPECT_EQ(wide, packet.parseUnicode());
	EXPECT_EQ(packet.size(), packet.getOffset());
}

TEST(PacketStreamTest, CountedUnicodeCopiesInitializePadding) {
	const UnicodeString::UnicodeCharType units[] = {'a', 0, 'b'};
	UnicodeString original;
	original.append(units, 3);
	UnicodeString copy(original);
	UnicodeString assigned;
	assigned = copy;
	Packet packet;
	packet.insertUnicode(assigned);
	packet.reset();
	EXPECT_EQ(3u, packet.parseInt());
	EXPECT_EQ('a', packet.parseShort());
	EXPECT_EQ(0, packet.parseShort());
	EXPECT_EQ(0, packet.parseShort());
}
