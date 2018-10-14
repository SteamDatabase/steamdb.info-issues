-- This is a partical database structure dump used by SteamDB
-- This structure is not final and can change at any time

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `Apps` (
  `AppID` int(7) UNSIGNED NOT NULL,
  `AppType` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `Name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SteamDB Unknown App',
  `StoreName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `LastKnownName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp(),
  `LastDepotUpdate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`AppID`) USING BTREE,
  KEY `LastUpdated` (`LastUpdated`),
  KEY `AppType` (`AppType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `AppsHistory` (
  `ID` int(9) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) UNSIGNED NOT NULL DEFAULT 0,
  `AppID` int(7) UNSIGNED NOT NULL,
  `Time` timestamp NOT NULL DEFAULT current_timestamp(),
  `Action` enum('created_app','deleted_app','created_key','removed_key','modified_key','created_info','modified_info','removed_info','added_to_sub','removed_from_sub') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Key` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `OldValue` longtext COLLATE utf8mb4_bin NOT NULL,
  `NewValue` longtext COLLATE utf8mb4_bin NOT NULL,
  `Diff` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

CREATE TABLE IF NOT EXISTS `AppsInfo` (
  `AppID` int(7) UNSIGNED NOT NULL,
  `Key` smallint(4) UNSIGNED NOT NULL,
  `Value` mediumtext COLLATE utf8mb4_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `AppsTypes` (
  `AppType` tinyint(2) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` varbinary(15) NOT NULL,
  `DisplayName` varchar(30) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`AppType`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `AppsTypes` (`AppType`, `Name`, `DisplayName`) VALUES
(0, 'unknown', 'Unknown'),
(1, 'game', 'Game'),
(2, 'application', 'Application'),
(3, 'demo', 'Demo'),
(4, 'dlc', 'DLC'),
(5, 'tool', 'Tool'),
(6, 'depotonly', 'Depot (not used)'),
(7, 'guide', 'Guide'),
(8, 'media', 'Legacy Media'),
(9, 'config', 'Config'),
(10, 'driver', 'Driver'),
(13, 'video', 'Video'),
(14, 'plugin', 'Plugin'),
(15, 'music', 'Music'),
(16, 'hardware', 'Hardware'),
(17, 'series', 'Series');

CREATE TABLE IF NOT EXISTS `Builds` (
  `BuildID` int(8) UNSIGNED NOT NULL,
  `ChangeID` int(9) NOT NULL,
  `AppID` int(9) UNSIGNED NOT NULL,
  PRIMARY KEY (`BuildID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Changelists` (
  `ChangeID` int(11) UNSIGNED NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ChangeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `ChangelistsApps` (
  `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) UNSIGNED NOT NULL,
  `AppID` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `ChangelistsSubs` (
  `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) UNSIGNED NOT NULL,
  `SubID` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Depots` (
  `DepotID` int(7) UNSIGNED NOT NULL,
  `Name` varchar(1000) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'SteamDB Unknown Depot',
  `BuildID` int(7) UNSIGNED NOT NULL DEFAULT 0,
  `ManifestID` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Displayed on the website, used for history',
  `LastManifestID` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Only updated after file list was successfully updated',
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`DepotID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `DepotsFiles` (
  `ID` int(9) UNSIGNED NOT NULL AUTO_INCREMENT,
  `DepotID` int(7) UNSIGNED NOT NULL,
  `File` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `Hash` binary(20) DEFAULT NULL,
  `Size` bigint(20) UNSIGNED NOT NULL,
  `Flags` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `File` (`DepotID`,`File`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `DepotsHistory` (
  `ID` int(9) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) UNSIGNED NOT NULL,
  `DepotID` int(7) UNSIGNED NOT NULL,
  `Time` timestamp NOT NULL DEFAULT current_timestamp(),
  `Action` enum('added','removed','modified','modified_flags','manifest_change','added_to_sub','removed_from_sub') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `File` varchar(300) CHARACTER SET utf8mb4 NOT NULL,
  `OldValue` bigint(20) UNSIGNED NOT NULL,
  `NewValue` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `DepotsKeys` (
  `DepotID` int(7) UNSIGNED NOT NULL,
  `Key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `LastUpdate` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`DepotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `GC` (
  `AppID` int(7) UNSIGNED NOT NULL,
  `Status` varchar(80) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `ImportantApps` (
  `ID` int(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `AppID` int(7) UNSIGNED NOT NULL,
  `Channel` varchar(50) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `AppID` (`AppID`,`Channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `ImportantSubs` (
  `SubID` int(7) UNSIGNED NOT NULL,
  UNIQUE KEY `AppID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `KeyNames` (
  `ID` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `Name` varchar(90) COLLATE utf8mb4_bin NOT NULL,
  `DisplayName` varchar(120) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `KeyNamesSubs` (
  `ID` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `Name` varchar(90) COLLATE utf8mb4_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `PICSTokens` (
  `AppID` int(7) NOT NULL,
  `Token` bigint(20) UNSIGNED NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `RSS` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `Link` varchar(300) COLLATE utf8mb4_bin NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Link` (`Link`(255)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Subs` (
  `SubID` int(7) UNSIGNED NOT NULL,
  `Name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SteamDB Unknown Package',
  `StoreName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `LastKnownName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`SubID`) USING BTREE,
  KEY `LastUpdated` (`LastUpdated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `SubsApps` (
  `SubID` int(7) UNSIGNED NOT NULL,
  `AppID` int(7) UNSIGNED NOT NULL,
  `Type` enum('app','depot') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  UNIQUE KEY `Unique` (`SubID`,`AppID`),
  KEY `AppID` (`AppID`),
  KEY `SubID` (`SubID`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `SubsHistory` (
  `ID` int(9) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) UNSIGNED NOT NULL DEFAULT 0,
  `SubID` int(7) UNSIGNED NOT NULL,
  `Time` timestamp NOT NULL DEFAULT current_timestamp(),
  `Action` enum('created_sub','deleted_sub','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Key` smallint(4) UNSIGNED NOT NULL,
  `OldValue` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `NewValue` mediumtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `SubsInfo` (
  `SubID` int(7) UNSIGNED NOT NULL,
  `Key` smallint(4) UNSIGNED NOT NULL,
  `Value` text COLLATE utf8mb4_bin NOT NULL,
  UNIQUE KEY `SubID` (`SubID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
