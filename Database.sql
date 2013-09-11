-- This is a partical database structure dump used by SteamDB
-- This structure is not final and can change at any time

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Apps` (
  `AppID` int(7) NOT NULL,
  `AppType` smallint(2) NOT NULL DEFAULT '0',
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown App',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsHistory` (
  `ID` int(9) NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) NOT NULL,
  `AppID` int(7) NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_app','deleted_app','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) NOT NULL DEFAULT '0',
  `OldValue` mediumtext COLLATE utf8_bin NOT NULL,
  `NewValue` mediumtext COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsInfo` (
  `AppID` int(7) NOT NULL,
  `Key` smallint(4) NOT NULL,
  `Value` mediumtext COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsTypes` (
  `AppType` smallint(2) NOT NULL AUTO_INCREMENT,
  `Name` varbinary(15) NOT NULL,
  `DisplayName` varbinary(30) NOT NULL,
  PRIMARY KEY (`AppType`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=11 ;

INSERT INTO `AppsTypes` (`AppType`, `Name`, `DisplayName`) VALUES
(0, 'unknown', 'Unknown'),
(1, 'game', 'Game'),
(2, 'application', 'Application'),
(3, 'demo', 'Game Demo'),
(4, 'dlc', 'DLC'),
(5, 'tool', 'Tool'),
(6, 'depotonly', 'Depot'),
(7, 'guide', 'Guide'),
(8, 'media', 'Media'),
(9, 'config', 'Config'),
(10, 'driver', 'Driver');

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Changelists` (
  `ChangeID` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id` (`ChangeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ChangelistsApps` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) NOT NULL,
  `AppID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `change_id` (`ChangeID`,`AppID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ChangelistsSubs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) NOT NULL,
  `SubID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`SubID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `GC` (
  `AppID` int(7) NOT NULL,
  `Status` varchar(80) COLLATE utf8_bin NOT NULL,
  `Version` int(10) NOT NULL DEFAULT '0',
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ImportantApps` (
  `AppID` int(7) NOT NULL,
  `Announce` tinyint(1) NOT NULL DEFAULT '0',
  `Graph` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ImportantSubs` (
  `SubID` int(7) NOT NULL,
  UNIQUE KEY `AppID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `KeyNames` (
  `ID` smallint(4) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `KeyNamesSubs` (
  `ID` smallint(4) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Subs` (
  `SubID` int(7) NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'Unknown Sub Name',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `SubID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsApps` (
  `SubID` int(7) NOT NULL,
  `AppID` int(7) NOT NULL,
  `Type` enum('app','depot') COLLATE utf8_bin NOT NULL DEFAULT 'app',
  UNIQUE KEY `SubID` (`SubID`,`AppID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsHistory` (
  `ID` int(9) NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) NOT NULL,
  `SubID` int(7) NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_sub','deleted_sub','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) NOT NULL,
  `OldValue` text COLLATE utf8_bin NOT NULL,
  `NewValue` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsInfo` (
  `SubID` int(7) NOT NULL,
  `Key` smallint(4) NOT NULL,
  `Value` text COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `SubID` (`SubID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
