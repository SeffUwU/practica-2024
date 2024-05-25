import { PrismaClient } from "@prisma/client";
import { parties } from "./seed/parties";
import { documentNames } from "./seed/documents";
import { randomBytes } from "crypto";

const prisma = new PrismaClient();

async function main() {
  // Создать собственников + документы
  const result = await Promise.all(
    parties.map(({ name, ...address }, idx) =>
      prisma.partyOwner.create({
        data: {
          name: name,
          partyOwnerAddress: {
            create: address,
          },
          documents: {
            createMany: {
              data: documentNames
                .slice(idx * 10, idx * 10 + 10)
                .map((name) => ({ location: "Архив", name })),
            },
          },
        },
        include: { documents: true },
      })
    )
  );

  const partyIds = result.map(({ id }) => id);
  // Наполнить таблицу пермещений
  await prisma.documentMovements.createMany({
    data: (
      await Promise.all(
        result
          .map(async ({ documents }) => {
            return await Promise.all(
              documents.map(async (doc) => {
                let rand =
                  partyIds[Math.floor(Math.random() * partyIds.length)];
                while (rand === doc.partyOwnerId) {
                  rand = partyIds[Math.floor(Math.random() * partyIds.length)];
                }
                await prisma.document.update({
                  where: { id: doc.id },
                  data: {
                    partyOwnerId: rand,
                  },
                });
                return {
                  fromPartyId: doc.partyOwnerId,
                  toPartyId: rand,
                  documentId: doc.id,
                };
              })
            );
          })
          .flat()
      )
    ).flat(),
  });

  const documents = result.map(({ documents }) => documents).flat();

  // Наполнить таблицу данных документов
  await prisma.documentData.createMany({
    data: documents.map((doc) => ({
      data: randomBytes(Math.floor(Math.random() * 512) + 1 + 1024),
      documentId: doc.id,
    })),
  });
}

main()
  .then(async () => {
    console.log("Seeding completed successfully");
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(`Error during seeding: ${e}`);
    await prisma.$disconnect();
    process.exit(1);
  });
