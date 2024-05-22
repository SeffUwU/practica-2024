-- CreateTable
CREATE TABLE "Document" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "partyOwnerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartyOwner" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "PartyOwner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartyOwnerAddress" (
    "id" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "street" TEXT NOT NULL,
    "houseNo" INTEGER NOT NULL,
    "partyOwnerId" TEXT NOT NULL,

    CONSTRAINT "PartyOwnerAddress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentMovements" (
    "id" TEXT NOT NULL,
    "fromPartyId" TEXT,
    "toPartyId" TEXT,
    "movedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DocumentMovements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentData" (
    "id" TEXT NOT NULL,
    "data" BYTEA NOT NULL,
    "documentId" TEXT NOT NULL,

    CONSTRAINT "DocumentData_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Document_name_idx" ON "Document"("name");

-- CreateIndex
CREATE INDEX "PartyOwner_name_idx" ON "PartyOwner"("name");

-- CreateIndex
CREATE UNIQUE INDEX "PartyOwnerAddress_partyOwnerId_key" ON "PartyOwnerAddress"("partyOwnerId");

-- CreateIndex
CREATE INDEX "PartyOwnerAddress_country_idx" ON "PartyOwnerAddress"("country");

-- CreateIndex
CREATE INDEX "PartyOwnerAddress_city_idx" ON "PartyOwnerAddress"("city");

-- CreateIndex
CREATE INDEX "PartyOwnerAddress_street_idx" ON "PartyOwnerAddress"("street");

-- CreateIndex
CREATE INDEX "PartyOwnerAddress_partyOwnerId_idx" ON "PartyOwnerAddress"("partyOwnerId");

-- CreateIndex
CREATE INDEX "PartyOwnerAddress_houseNo_idx" ON "PartyOwnerAddress"("houseNo");

-- CreateIndex
CREATE INDEX "DocumentMovements_fromPartyId_toPartyId_idx" ON "DocumentMovements"("fromPartyId", "toPartyId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentData_documentId_key" ON "DocumentData"("documentId");

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_partyOwnerId_fkey" FOREIGN KEY ("partyOwnerId") REFERENCES "PartyOwner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartyOwnerAddress" ADD CONSTRAINT "PartyOwnerAddress_partyOwnerId_fkey" FOREIGN KEY ("partyOwnerId") REFERENCES "PartyOwner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentMovements" ADD CONSTRAINT "DocumentMovements_fromPartyId_fkey" FOREIGN KEY ("fromPartyId") REFERENCES "PartyOwner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentMovements" ADD CONSTRAINT "DocumentMovements_toPartyId_fkey" FOREIGN KEY ("toPartyId") REFERENCES "PartyOwner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentData" ADD CONSTRAINT "DocumentData_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;
