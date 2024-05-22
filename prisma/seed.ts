import { PrismaClient } from "@prisma/client";
import { parties } from "./seed/parties";
import { documentNames } from "./seed/documents";

const prisma = new PrismaClient();

async function main() {
	await Promise.all(
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
			}),
		),
	);
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
