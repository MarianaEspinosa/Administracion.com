-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema administracion.com
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema administracion.com
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `administracion.com` DEFAULT CHARACTER SET utf8 ;

USE `administracion.com` ;

-- -----------------------------------------------------
-- Table `administracion.com`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `administracion.com`.`usuario` (
  `cedula` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `nroVivienda` VARCHAR(45) NULL,
  `telefono` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `contraseña` VARCHAR(45) NULL,
  `fechaRegistro` DATE NULL,
  `fechaPagoOp` DATE NULL,
  `estadoPago` VARCHAR(1) NULL,
  PRIMARY KEY (`cedula`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `administracion.com`.`administradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `administracion.com`.`administradores` (
  `idAdministrador` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `idConjunto` INT NULL,
  PRIMARY KEY (`idAdministrador`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `administracion.com`.`conjuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `administracion.com`.`conjuntos` (
  `idConjunto` INT NOT NULL,
  `direccion` VARCHAR(45) NULL,
  `idAdministrador` INT NOT NULL,
  PRIMARY KEY (`idConjunto`),
  INDEX `fk_conjuntos_administradores1_idx` (`idAdministrador` ASC) VISIBLE,
  CONSTRAINT `fk_conjuntos_administradores1`
    FOREIGN KEY (`idAdministrador`)
    REFERENCES `administracion.com`.`administradores` (`idAdministrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `administracion.com`.`vivienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `administracion.com`.`vivienda` (
  `nroVivienda` INT NOT NULL,
  `cedula` INT NULL,
  `idConjunto` INT NOT NULL,
  PRIMARY KEY (`nroVivienda`),
  INDEX `fk_vivienda_usuario_idx` (`cedula` ASC) VISIBLE,
  INDEX `fk_vivienda_conjuntos1_idx` (`idConjunto` ASC) VISIBLE,
  CONSTRAINT `fk_vivienda_usuario`
    FOREIGN KEY (`cedula`)
    REFERENCES `administracion.com`.`usuario` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vivienda_conjuntos1`
    FOREIGN KEY (`idConjunto`)
    REFERENCES `administracion.com`.`conjuntos` (`idConjunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `administracion.com`.`facturas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `administracion.com`.`facturas` (
  `idFacturas` INT NOT NULL,
  `fechaPago` DATETIME NULL,
  `cedula` INT NOT NULL,
  PRIMARY KEY (`idFacturas`),
  INDEX `fk_facturas_usuario1_idx` (`cedula` ASC) VISIBLE,
  CONSTRAINT `fk_facturas_usuario1`
    FOREIGN KEY (`cedula`)
    REFERENCES `administracion.com`.`usuario` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

