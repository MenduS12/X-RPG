//==============================================================================//
/*
	* Module: weapons.pwn
	* Author: Sule
	* Date: 12.04.2020
*/
//==============================================================================//
#define MAX_W_SLOTS 13
//==============================================================================//
enum weaponInfo
{
	wName[24],
	wID,
	wSlot,
	wModel
}
//=======================================//
new WeaponInfo[47][weaponInfo] = 
{
	{ "None", 0, 0, 0 },
	{ "Brass Knuckles", 1, 0, 331 },
	{ "Golf Club", 2, 1, 333 },
	{ "Nightstick", 3, 1, 334 },
	{ "Knife", 4, 1, 335 },
	{ "Baseball Bat", 5, 1, 336 },
	{ "Shovel", 6, 1, 337 },
	{ "Pool Cue", 7, 1, 338 },
	{ "Katana", 8, 1, 339 },
	{ "Chainsaw", 9, 1, 341 },
	{ "Double-ended Dildo", 10, 10, 321 },
	{ "Dildo", 11, 10, 321 },
	{ "Vibrator", 12, 10, 323 },
	{ "Silver Vibrator", 13, 10, 324 },
	{ "Flowers", 14, 10, 325 },
	{ "Cane", 15, 10, 326 },
	{ "Grenade", 16, 8, 342 },
	{ "Tear Gas", 17, 8, 343 },
	{ "Molotov Cocktail", 18, 8, 344 },
	{ "No gun", 19, -1, 0 },
	{ "No gun", 20, -1, 0 },
	{ "No gun", 21, -1, 0 },
	{ "Colt .45", 22, 2, 346 },
	{ "Silenced Colt .45", 23, 2, 347 },
	{ "Desert Eagle", 24, 2, 348 },
	{ "Shotgun", 25, 3, 349 },
	{ "Sawnoff Shotgun", 26, 3, 350 },
	{ "Combat Shotgun", 27, 3, 351 },
	{ "Micro SMG", 28, 4, 352 },
	{ "MP5", 29, 4, 353 },
	{ "AK47", 30, 5, 355 },
	{ "M4", 31, 5, 356 },
	{ "Tec-9", 32, 4, 372 },
	{ "Country Rifle", 33, 6, 357 },
	{ "Sniper Rifle", 34, 6, 358 },
	{ "RPG", 35, 7, 359 },
	{ "HS Rocket", 36, 7, 0 },
	{ "Flamethrower", 37, 7, 361 },
	{ "Minigun", 38, 7, 362 },
	{ "Satchel Charge", 39, 8, 363 },
	{ "Detonator", 40, 12, 364 },
	{ "Spraycan", 41, 9, 365 },
	{ "Fire Extinguisher", 42, 9, 366 },
	{ "Camera", 43, 9, 367 },
	{ "Night Vis Goggles", 44, 11, 368 },
	{ "Thermal Goggles", 45, 11, 369 },
	{ "Parachute", 46, 11, 371 }
};
//==============================================================================//